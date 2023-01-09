class PagesController < ApplicationController
  def home
    places = Place.map_data
    render Views::Pages::Home.new(places:)
  end
end
