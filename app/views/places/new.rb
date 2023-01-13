module Views
  class Places::New < Phlex::HTML
    include ApplicationView

    register_element :turbo_frame

    def initialize(place:)
      @place = place
    end

    def template
      div(class: "") do
        text @place.to_json
        render Views::NewMap.new
      end
    end
  end
end
