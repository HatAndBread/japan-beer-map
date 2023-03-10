class PlacesController < ApplicationController
  before_action :authenticate_needing_approval!, only: [:show]
  before_action :authenticate_user!, only: [:new, :create, :update]

  def show
    render Views::Places::Show.new(place: @place)
  end

  def new
    render Views::Places::New.new
  end

  def create
    @place = Place.new(place_params)
    @place.periods = JSON.parse(@place.periods)
    @place.approved = !!current_user&.admin?
    result = @place.save!
    if result
      flash[:notice] = current_user.admin? ? "New place added with admin privileges" : "Place successfully submitted. We will approve your submission soon."
    else
      flash[:alert] = "A server error prevented submission of this business. Please try again later."
    end
    redirect_to map_path
    return if current_user&.admin?
    User.where(admin: true).each do |admin|
      UserMailer.new_place_admin_review(admin, @place).deliver_now
    end
  end

  def update
    @place = Place.find(params[:id])
    @place.update(update_params)
    respond_to { |format| format.turbo_stream }
  end

  private

  def place_params
    params.require(:place)
      .permit(:lng, :lat, :website, :google_maps_url, :periods, :name, :address, :phone, :google_place_id, :has_food, :is_shop, :is_brewery, :user_id, photos: [])
  end

  def update_params
    params.require(:place).permit(photos: [])
  end

  def authenticate_needing_approval!
    @place = Place.includes(:visits, reviews: :user).find(params[:id])
    redirect_to root_path unless @place.approved? || current_user&.admin?
  end
end
