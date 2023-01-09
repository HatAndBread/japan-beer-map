class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
  validates :locale, inclusion: {in: %w[en ja], message: "%{value} is not a valid locale"}
  validates :email, uniqueness: true

  has_many :reviews
  has_many :places
end
