
puts "Cleaning database.. 🧹"
`rails db:schema:load`

def seed_users
  [
    {email: "spaceprophet@gmail.com", password: ENV["ADMIN_PASSWORD"], username: "Joshua", admin: true},
    {email: "hello@beermap.jp", password: ENV["ADMIN_PASSWORD"], username: "Anonymous", admin: false},
    {email: "fred@fred.com", password: ENV["ADMIN_PASSWORD"], username: "Fred", admin: false}
  ].each do |attrs|
    puts "Creating user..."
    ap attrs
    User.create(attrs)
  end
end

def seed_places
  puts "Importing place data..."
  data = JSON.parse(File.read("data.json"))
  count = data.count
  data.each_with_index do |place, i|
    print "..#{((i / count.to_f).round(2) * 100).to_i}%" if i % 100 == 0
    place = place.with_indifferent_access
    next if place[:business_status] == "CLOSED_PERMANENTLY"
    is_a = ->(thing) { !!place[:types]&.find { |t| t == thing } }
    next if is_a.("zoo")

    lng = place[:geometry][:location][:lng]
    lat = place[:geometry][:location][:lat]
    website = place[:website]
    google_maps_url = place[:url]
    periods = place.dig(:opening_hours, :periods)
    name = place[:name]
    address = place[:formatted_address]
    phone = place[:formatted_phone_number]
    google_place_id = place[:place_id]
    is_restaurant = is_a.("restaurant")
    has_food = is_a.("food")
    is_shop = is_a.("liquor_store")
    is_bar = is_a.("bar")
    is_brewery = name.downcase.match?(/brewery/) || name.downcase.match?(/jozo/)
    google_photos = place[:photos]&.map do |photo|
      photo.dig(:raw_reference, :fife_url)
    end || []
    data = {lng:, lat:, website:, google_maps_url:, periods:, name:, address:, phone:, google_place_id:, is_restaurant:, has_food:, is_shop:, is_bar:, google_photos:, is_brewery:}
    p = Place.create(data)
    user = User.find_by(username: "Anonymous")
    place[:reviews]&.map do |review|
      attrs = {
        user:,
        place: p,
        text: review[:text],
        rating: review[:rating],
        time: Time.at(review[:time].to_i),
        language: review[:language]
      }
      Review.create!(attrs)
    end || []
  end
end

seed_users
seed_places
