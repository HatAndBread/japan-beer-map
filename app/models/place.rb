class Place < ApplicationRecord
  has_many :reviews
  belongs_to :user, optional: true

  def owner = user

  def map_data = all.pluck(:lng, :lat, :name, :is_brewery, :is_bar, :is_shop, :is_restaurant)
end
