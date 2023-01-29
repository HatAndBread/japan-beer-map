module Services
  class GoogleImporter
    def initialize(lat: 38.2682, lng: 140.8694, radius: 1000, query: "クラフトビール")
      @places = Place.all
      @url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat}%2C#{lng}&radius=#{radius}&keyword=#{CGI.escape(query)}&fields=formatted_address%2Cname%2Crating%2Ccurrent_opening_hours%2Cgeometry%2Cphotos%2Cbusiness_status%2Cformatted_phone_number%2Cwebsite&key=#{ENV["GOOGLE"]}"
    end

    def start
      data = get_data
      data.each_with_index do |place, i|
        next if place[:business_status] == "CLOSED_PERMANENTLY"
        next if Place.find_by(google_place_id: place[:place_id])
        next if Place.where(lng: place[:geometry][:location][:lng], lat: place[:geometry][:location][:lng]).exists?

        place = place_data(place)
        reviews = place[:reviews]
        place = unsaved_place(place)
        dupes = possible_duplicates(place)
        puts "*************** Reviews ****************"
        ap reviews
        puts "*************** Place ****************"
        ap place
        if dupes.any?
          puts "Possible duplicates!".red
          ap dupes
        end
        puts "Place #{i} out of #{data.size}".cyan
        puts place.google_maps_url
        print "Do you want to save this place? "
        answer = gets.chomp!
        if answer.downcase == "y"
          place.save!
          save_reviews!(reviews, place)
        end
      end
    end

    private

    def place_data(place)
      url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place[:place_id]}&key=#{ENV["GOOGLE"]}"
      result = JSON.parse(RestClient.get(url)).with_indifferent_access[:result]
      ap result
      result
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

    def save_reviews!(reviews, place)
      reviews.each do |review|
        attrs = {
          user: User.where(email: "hello@beermap.jp").first,
          place:,
          text: review[:text].delete("\n"),
          rating: review[:rating],
          time: Time.at(review[:time].to_i),
          language: review[:language]
        }
        Review.create!(attrs)
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
      google_photos = place[:photos]&.map do |photo|
        photo.dig(:raw_reference, :fife_url)
      end&.compact || []
      data = {lng:, lat:, website:, google_maps_url:, periods:, name:, address:, phone:, google_place_id:, has_food:, is_shop:, google_photos:, is_brewery:, approved: true}
      p = Place.new(data)
    end
  end
end
