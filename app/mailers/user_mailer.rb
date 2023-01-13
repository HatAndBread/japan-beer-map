class UserMailer < ApplicationMailer
  def new_place_admin_review(user, place)
    @user = user
    @place = place
    mail(to: @user.email, subject: "A new place is waiting for a review")
  end
end
