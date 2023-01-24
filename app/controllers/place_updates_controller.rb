class PlaceUpdatesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!, only: [:destroy]

  def index
    @place_update = PlaceUpdate.create(place_id: params[:place_id])
    @place = @place_update.place
    render Views::PlaceUpdates::Index.new(place: @place, place_update: @place_update)
  end

  def update
    if current_user.admin?
      admin_update
    else
      @place_update = PlaceUpdate.find(params[:id])
      @place_update.assign_attributes(place_update_params)
      @place_update.periods = JSON.parse(@place_update.periods)
      result = @place_update.save
      if result
        flash[:notice] = "Thank you for updating this business. We will review your submission soon!"
      else
        flash[:alert] = "An error occured. Please try again later."
      end
    end
    redirect_to map_path
    if result
      User.where(admin: true).each do |admin|
        UpdateMailer.update_place_admin_review(admin, @place_update).deliver_now
      end
    end
  end

  private

  def admin_update
    place = Place.find(params[:place_id])
    place.assign_attributes(admin_place_update_params)
    place.periods = JSON.parse(place.periods)
    result = place.save
    if result
      flash[:notice] = "Successfully updated place #{params[:place_id]} from the admin panel."
    else
      flash[:alert] = "An error occurred updating place #{params[:place_id]} from the admin_panel."
    end
  end

  def place_update_params
    params.require(:place_update).permit(:name, :phone, :text, :website, :periods, :address, :has_food, :is_shop, :is_brewery)
  end

  def admin_place_update_params
    params.require(:place_update).permit(:name, :phone, :website, :periods, :address, :has_food, :is_shop, :is_brewery)
  end
end
