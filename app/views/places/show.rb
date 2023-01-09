module Views
  class Places::Show < Phlex::HTML
    include ApplicationView

    def initialize(place:)
      @place = place
    end

    def template
      div(class: "") do
        @place.to_json
      end
    end
  end
end
