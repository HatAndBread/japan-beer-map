module Views
  class Map < Phlex::HTML
    register_element :turbo_frame

    def initialize(places:)
      @places = places
    end

    def template
      div(data_controller: "map", class: "w-full") do
        div(id: "the-map", class: "w-screen h-[800px]") do
          render MapControls.new
        end
        @places.map do |place|
          turbo_frame(id: "place_#{place.id}", class: "marker hidden", data_food: place.has_food, data_brewery: place.is_brewery, data_shop: place.is_shop) do
            a(href: helpers.place_path(place), data_lng: place.lng, data_lat: place.lat, data_id: place.id, data_turbo_frame: "place_being_viewed")
          end
        end
        div(class: "w-[32px] h-[32px] hidden", data_map_target: "userLocation") do
          div(class: "animate-ping absolute inline-flex h-full w-full rounded-full bg-sky-400 opacity-75") do
          end
          img(src: helpers.image_path("location.png"), class: "z-10")
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
