class PlacesController < ApplicationController
  before_action :authenticate_needing_approval!, only: [:show]

  def show
    render Views::Places::Show.new(place: @place)
  end

  def new
    render Views::Places::New.new(place: Place.new)
  end

  def create
    # Don't actually create a place yet.
    # Notify admin to approve it to avoid spam.
    @place = Place.create(place_params)
    User.where(admin: true).each do |admin|
      UserMailer.new_place_admin_review(admin, @place).deliver_now
    end
  end

  private

  def place_params
    params.require(:place).permit(:lng, :lat, :website, :google_maps_url, :periods, :name, :address, :phone, :google_place_id, :has_food, :is_shop, :is_brewery, :user_id)
  end

  def authenticate_needing_approval!
    @place = Place.find(params[:id])
    redirect_to root_path unless @place.approved? || current_user&.admin?
  end
end
