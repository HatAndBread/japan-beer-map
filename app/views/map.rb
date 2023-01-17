module Views
  class Map < Phlex::HTML
    register_element :turbo_frame

    def initialize(places:, geo_json:)
      @places = places
      @geo_json = geo_json
    end

    def template
      meta(data_geo_json: @geo_json, id: "geo-json")
      div(data_controller: "map", class: "w-screen flex justify-center") do
        turbo_frame(id: "place_being_viewed")
        div(id: "the-map", class: "#{map_only? ? "w-screen h-[calc(100vh_-_64px)]" : "w-[90vw] h-screen"} rounded overflow-hidden") do
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

    def map_only?
      helpers.current_page?(helpers.map_path) || helpers.current_page?("/map")
    end

    def triangle
      "absolute h-0 w-0 bottom-[-8px] left-[4px] border-l-[12px] border-r-[12px] border-l-transparent border-r-transparent border-t-[12px] border-t-slate-800"
    end

    def tooltip
      "pointer-events-none invisible group-hover:visible bg-slate-800 text-white w-fit p-2 rounded absolute bottom-0"
    end
  end
end
