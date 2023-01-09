class PlacesController < ApplicationController
  def show
    place = Place.find(params[:id])
    render Views::Places::Show.new(place:)
  end
end
