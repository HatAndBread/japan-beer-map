module Views
  class Map < Phlex::HTML
    register_element :turbo_frame

    def initialize(places:)
      @places = places
    end

    def template
      div(id: "the-map", class: "w-[90vw] h-[800px]", data_controller: "map")
      @places.map do |place|
        turbo_frame(id: "place_#{place.id}", class: "marker group hover:z-10") do
          a(href: helpers.place_path(place), class: "relative", data_lng: place.lng, data_lat: place.lat, data_turbo_frame: "place_being_viewed") do
            div(class: "pointer-events-none invisible group-hover:visible bg-slate-800 text-white w-fit p-2 rounded absolute bottom-0") do
              ul do
                li(class: "whitespace-nowrap") { place.name }
              end
              div(class: "absolute h-0 w-0 bottom-[-8px] left-[4px] border-l-[12px] border-r-[12px] border-l-transparent border-r-transparent border-t-[12px] border-t-slate-800")
            end
          end
        end
      end
    end
  end
end
