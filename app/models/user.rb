class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
  validates :locale, inclusion: {in: %w[en ja], message: "%{value} is not a valid locale"}
  validates :email, uniqueness: true
  validates :username, presence: true, uniqueness: {case_sensitive: false}
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true

  after_commit :create_profile!, on: [:create]

  has_many :reviews
  has_many :visits
  has_many :places
  has_one :profile

  attr_writer :login

  class << self
    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if (login = conditions.delete(:login))
        where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", {value: login.downcase}]).first
      elsif conditions.has_key?(:username) || conditions.has_key?(:email)
        where(conditions.to_h).first
      end
    end

    def race
      Rails.cache.fetch("race", expires_in: 12.hours) do
        includes(visits: [:place]).all.filter_map { |user| {user:, unique_visits: user.visits.map { |v| v.place_id }.uniq.size} if user.visits.count.positive? }
          .sort_by { |u| u[:unique_visits] }
          .reverse
      end
    end
  end

  def login
    @login || self.username || self.email
  end

  private

  def create_profile!
    Profile.create(user: self, email:)
  end
end
