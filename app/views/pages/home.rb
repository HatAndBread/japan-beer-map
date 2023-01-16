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
      div(class: "flex flex-col items-center") do
        h1(class: "text-3xl text-center") { helpers.t(:hello) }
        img(src: helpers.image_path("bg.png"), class: "rounded-full max-w-[400px] w-[90%]")
        turbo_frame(id: "place_being_viewed")
        render Views::Map.new(places: @places)
      end
    end
  end
end
