class Place < ApplicationRecord
  has_many :reviews
  belongs_to :user, optional: true
  after_commit :clear_cache!, on: [:create, :update, :destroy]

  class << self
    def map_data
      Rails.cache.fetch("all_places", expires_in: 12.hours) do
        select(:id, :lng, :lat, :name, :is_brewery, :is_bar, :is_shop, :is_restaurant, :has_food).to_a
      end
    end

    def geo_json
      {
        type: "geojson",
        data: {
          type: "FeatureCollection",
          features: all.map do |place|
            {
              type: "Feature",
              geometry: {
                type: "Point",
                coordinates: [place.lng, place.lat]
              },
              properties: {
                id: place.id,
                lng: place.lng,
                lat: place.lat,
                name: place.name,
                is_brewery: place.is_brewery,
                is_bar: place.is_bar,
                is_shop: place.is_shop,
                is_restaurant: place.is_restaurant,
                has_food: place.has_food
              }
            }
          end
        }
      }.to_json
    end
  end

  def owner = user

  private

  def clear_cache!
    Rails.cache.delete("all_places")
  end
end
