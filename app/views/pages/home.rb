module Views
  class Pages::Home < Phlex::HTML
    include ApplicationView
    def initialize(places:)
      @places = places
    end

    def template
      div(class: "") do
        h1 { helpers.t(:hello) }
        render Views::Map.new(places: @places)
      end
    end
  end
end
