class PlacesController < ApplicationController
  def show
    place = Place.find(params[:id])
    100.times {Rails.logger.debug request.headers}
    render Views::Places::Show.new(place:)
  end

  def new
    render Views::Places::New.new(place: Place.new)
  end

  def create

  end
end
