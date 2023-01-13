class Admin::PlacesController < ApplicationController
  before_action :authenticate_admin!
  before_action :place

  def show
    render Views::Places::Show.new(place: @place)
  end

  def update
    Rails.logger.debug("++++++++++++++++++++++++++++++++++++++++")
    Rails.logger.debug(params)
    Rails.logger.debug(place_params)
    @place.update(place_params)
    render Views::Places::Show.new(place: @place)
  end

  def destroy
    @place.destroy!
    redirect_to admin_index_path
  end

  private

  def place
    @place = Place.find(params[:id])
  end

  def place_params
    params.require(:place).permit(:approved)
  end
end
