class Place < ApplicationRecord
  has_many :reviews
  belongs_to :user, optional: true

  def owner = user
end
