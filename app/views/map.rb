module Views
  class Map < Phlex::HTML
    register_element :turbo_frame

    def initialize(places:)
      @places = places
    end

    def template
      div do
        render MapControls.new
        div(id: "the-map", class: "w-[90vw] h-[800px]", data_controller: "map")
        @places.map do |place|
          turbo_frame(id: "place_#{place.id}", class: "marker group hover:z-10", data_food: place.has_food || place.is_restaurant, data_brewery: place.is_brewery, data_shop: place.is_shop) do
            a(href: helpers.place_path(place), class: "relative", data_lng: place.lng, data_lat: place.lat, data_turbo_frame: "place_being_viewed") do
              div(class: tooltip) do
                ul do
                  li(class: "whitespace-nowrap") { place.name }
                end
                div(class: triangle)
              end
            end
          end
        end
      end
    end

    private

    def triangle
      "absolute h-0 w-0 bottom-[-8px] left-[4px] border-l-[12px] border-r-[12px] border-l-transparent border-r-transparent border-t-[12px] border-t-slate-800"
    end

    def tooltip
      "pointer-events-none invisible group-hover:visible bg-slate-800 text-white w-fit p-2 rounded absolute bottom-0"
    end
  end
end
