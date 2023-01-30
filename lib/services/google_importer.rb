module Services
  class GoogleImporter
    def initialize(lat:, lng:, radius:)
      query = "クラフトビール"
      lat ||= 38.2682
      lng ||= 140.8694
      radius ||= 2000
      @places = Place.all;nil
      @url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat}%2C#{lng}&radius=#{radius}&keyword=#{CGI.escape(query)}&fields=formatted_address%2Cname%2Crating%2Ccurrent_opening_hours%2Cgeometry%2Cphotos%2Cbusiness_status%2Cformatted_phone_number%2Cwebsite&key=#{ENV["GOOGLE"]}"
      @new_places = []
    end

    def start
      data = get_data
      data.each_with_index do |place, i|
        next if place[:business_status] == "CLOSED_PERMANENTLY"
        next if Place.find_by(google_place_id: place[:place_id])
        next if Place.where(lng: place[:geometry][:location][:lng], lat: place[:geometry][:location][:lng]).exists?

        place = place_data(place)
        google_photos = photos(place)
        reviews = place[:reviews] || []
        place = unsaved_place(place)
        place.google_photos = google_photos
        dupes = possible_duplicates(place)
        puts "*************** Reviews ****************"
        ap reviews
        puts "*************** Place ****************"
        ap place
        if dupes.any?
          puts "Possible duplicates!".red
          ap dupes
          puts "Possible duplicates!!!!!".red
        end
        puts "Place #{i} out of #{data.size}".cyan
        puts place.google_maps_url
        print "Do you want to save this place? "
        answer = gets.chomp!
        if answer.downcase == "y"
          @new_places << [place.attributes, review_attrs(reviews)]
        end
      end
      puts "Here is the new place code!".cyan
      puts "data = %|#{@new_places.to_json}|;data=JSON.parse(data);data.each{|p| o = Place.create!(p.first); p.second.each{|r| r = Review.new(r); r.place_id = o.id;r.save! }};"
    end

    private

    def place_data(place)
      url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place[:place_id]}&key=#{ENV["GOOGLE"]}"
      JSON.parse(RestClient.get(url)).with_indifferent_access[:result]
    end

    def photos(place)
      response = RestClient.get place[:url]
      response.body.scan(/https:\/\/lh5\.googleusercontent\.com\/p\/\w+\\/).to_a.map { |x| x.chop }
    end

    def get_data
      result = JSON.parse(RestClient.get(@url)).with_indifferent_access[:results]
      ap result
      result
    end

    def possible_duplicates(place)
      @places.select do |p|
        p.lng.round(3) == place.lng.round(3) && p.lat.round(3) == place.lng.round(3)
      end
    end

    def review_attrs(reviews)
      reviews.map do |review|
        {
          user_id: User.where(email: "hello@beermap.jp").first.id,
          text: review[:text].delete("\n"),
          rating: review[:rating],
          time: Time.at(review[:time].to_i),
          language: review[:language]
        }
      end
    end

    def unsaved_place(place)
      is_a = ->(thing) { !!place[:types]&.find { |t| t == thing } }

      lng = place[:geometry][:location][:lng]
      lat = place[:geometry][:location][:lat]
      website = place[:website]
      google_maps_url = place[:url]
      periods = place.dig(:opening_hours, :periods)
      name = place[:name]
      address = place[:formatted_address]
      phone = place[:formatted_phone_number]
      google_place_id = place[:place_id]
      has_food = is_a.("restaurant")
      has_food ||= is_a.("food")
      is_shop = is_a.("liquor_store")
      is_brewery = name.downcase.match?(/brewery/) || name.downcase.match?(/jozo/)
      data = {lng:, lat:, website:, google_maps_url:, periods:, name:, address:, phone:, google_place_id:, has_food:, is_shop:, is_brewery:, approved: true}
      Place.new(data)
    end
  end
end
