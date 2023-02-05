class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :place
  validates_each :time do |record, attr, value|
    record.errors.add(attr, "cannot visit same place more than once per day") if visited_today?(record)
  end
  class << self
    def visited_today?(record)
      Time.zone = "Japan"
      where(user_id: record.user_id, place_id: record.place_id, time: Time.current.to_date.all_day).exists?
    end
  end

  def visit_count
    self.class.where(user:, place:).count
  end
end
