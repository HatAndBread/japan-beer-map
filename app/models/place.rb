class Place < ApplicationRecord
  has_many :reviews
  belongs_to :user, optional: true
  after_commit :clear_cache!, on: [:create, :update, :destroy]

  class << self
    def map_data
      Rails.cache.fetch("all_places", expires_in: 12.hours) do
        select(:id, :lng, :lat, :name, :is_brewery, :is_bar, :is_shop, :is_restaurant).to_json
      end
    end
  end

  def owner = user

  private

  def clear_cache!
    Rails.cache.delete("all_places")
  end
end
