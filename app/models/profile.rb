class Profile < ApplicationRecord
  after_commit :update_user!, on: [:update]
  belongs_to :user
  has_one_attached :photo

  private

  def update_user!
    user.update(email:)
  end
end
