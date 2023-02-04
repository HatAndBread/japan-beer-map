module Views
  class Pages::Home < Phlex::HTML
    include ApplicationView

    register_element :turbo_frame

    def initialize(places:, geo_json:)
      @places = places
      @geo_json = geo_json
    end

    def template
      div(class: "flex flex-col items-center mb-[400px] lg:mb-0") do
        render Views::Hero.new(places: @places, geo_json: @geo_json)
        # render Views::HowItWorks.new
      end
    end
  end
end
