module Views
  class Pages::Home < Phlex::HTML
    include ApplicationView

    register_element :turbo_frame

    def initialize(places:, geo_json:)
      @places = places
      @geo_json = geo_json
    end

    def template
      div(class: "flex flex-col items-center") do
        render Views::Hero.new
        render Views::Map.new(places: @places, geo_json: @geo_json)
      end
    end
  end
end
