class VisitsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :create]

  def index
    visits = Visit.where(user_id: current_user.id).includes(:place)
    render Views::Visits::Index.new(visits:)
  end

  def create
    Time.zone = "Japan"
    visit = Visit.create(visit_params.merge(time: Time.zone.now, user_id: current_user.id))
    render Views::Places::Visit.new(visit:)
  end

  private

  def visit_params
    params.require(:visit).permit(:place_id)
  end
end
