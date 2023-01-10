module Views
  class Pages::Home < Phlex::HTML
    include ApplicationView

    register_element :turbo_frame

    def initialize(places:, geo_json:)
      @places = places
      @geo_json = geo_json
    end

    def template
      meta(data_geo_json: @geo_json, id: "geo-json")
      div(class: "") do
        h1 { helpers.t(:hello) }
        turbo_frame(id: "place_being_viewed") do
        end

        render Views::Map.new(places: @places)
      end
    end
  end
end
