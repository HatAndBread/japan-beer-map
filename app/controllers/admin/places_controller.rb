class Admin::PlacesController < ApplicationController
  before_action :authenticate_admin!
  before_action :place

  def show
    render Views::Admin::Places::Show.new(place: @place)
  end

  def update
    result = @place.update(place_params)
    if result
      flash[:notice] = "Place successfully added"
    else
      flash[:alert] = "Error adding place! #{@place.id}"
    end
    redirect_to admin_path
  end

  def destroy
    result = @place.destroy!
    if result
      flash[:notice] = "Place successfully deleted"
    else
      flash[:alert] = "Error deleting place! #{@place.id}"
    end
    redirect_to admin_path
  end

  private

  def place
    @place = Place.find(params[:id])
  end

  def place_params
    params.require(:place).permit(:approved)
  end
end
