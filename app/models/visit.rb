class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :place

  def visit_count
    self.class.where(user:, place:).count
  end
end
