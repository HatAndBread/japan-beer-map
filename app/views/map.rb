module Views
  class Map < Phlex::HTML
    def initialize(places:)
      @places = places
    end

    def template
      div(id: "the-map", class: "w-[90vw] h-[800px]", data_controller: "map", data_places: @places)
    end
  end
end
