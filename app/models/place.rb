class Place < ApplicationRecord
  has_many :reviews
  belongs_to :user

  def owner = user
end
