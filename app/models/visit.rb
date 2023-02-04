class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :place
  after_save :clear_cache!
  class << self
    def race
      data = includes(:user, :place).all
      data.each_with_object({}) do |d, h|
        h[d.user] ||= []
      end
    end
  end

  def visit_count
    self.class.where(user:, place:).count
  end

  private

  def clear_cache!
    Rails.cache.delete("race")
  end
end
