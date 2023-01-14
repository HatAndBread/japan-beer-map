class Place < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many_attached :photos
  belongs_to :user, optional: true
  after_commit :clear_cache!, on: [:create, :update, :destroy]

  class << self
    def map_data
      Rails.cache.fetch("all_places", expires_in: 12.hours) do
        approved.select(:id, :lng, :lat, :name, :is_brewery, :is_shop, :has_food).to_a
      end
    end

    def geo_json
      Rails.cache.fetch("geo_json", expires_in: 12.hours) do
        {
          type: "geojson",
          data: {
            type: "FeatureCollection",
            features: approved.map do |place|
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
                  is_shop: place.is_shop,
                  has_food: place.has_food
                }
              }
            end
          }
        }.to_json
      end
    end

    def needs_approval = Place.where(approved: false)

    def approved = Place.where(approved: true)
  end

  def owner = user

  private

  def clear_cache!
    Rails.cache.delete("all_places")
    Rails.cache.delete("geo_json")
  end
end
