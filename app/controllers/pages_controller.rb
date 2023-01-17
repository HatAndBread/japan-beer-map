class PagesController < ApplicationController
  def home
    places = Place.map_data
    geo_json = Place.geo_json
    render Views::Pages::Home.new(places:, geo_json:)
  end

  def map
    render Views::Map.new(places: Place.map_data, geo_json: Place.geo_json)
  end
end
