class VisitsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    Time.zone = "Japan"
    Visit.create(visit_params.merge(time: Time.zone.now, user_id: current_user.id))
  end

  private

  def visit_params
    params.require(:visit).permit(:place_id)
  end
end
