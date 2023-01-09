module Views
  class Map < Phlex::HTML
    def template
      div(id: "the-map", class: "w-[90vw] h-[800px]", data_controller: "map")
    end
  end
end
