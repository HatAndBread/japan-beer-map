class UpdateMailer < ApplicationMailer
  def update_place_admin_review(user, place_update)
    @user = user
    @place_update = place_update
    mail(to: @user.email, subject: "A place has been updated and is waiting for a review")
  end
end
