module Views
  class Map < Phlex::HTML
    register_element :turbo_frame

    def initialize(places:, geo_json:)
      @places = places
      @geo_json = geo_json
    end

    def template
      meta(data_geo_json: @geo_json, id: "geo-json")
      div(id: "map-loader", class: "hidden top-0 w-screen h-screen fixed z-[100] flex items-center justify-center bg-[rgba(50,50,50,0.5)]") do
        div(class: "translate-y-[-104px] flex text-white md:text-xl flex-col items-center") do
          img(class: "mb-4 h-[88px]", src: helpers.image_path("puff.svg"))
          span(class: "flex items-end") do
            text("Finding your location. Please wait")
            img(class: "ml-2 w-[18px] translate-y-[-6px]", src: helpers.image_path("three-dots.svg"))
          end
        end
      end
      div(data_controller: "map", class: "w-screen flex justify-center") do
        div(id: "the-map", class: "#{map_only? ? "w-screen h-[calc(100vh_-_64px)]" : "w-[90vw] h-screen"} rounded overflow-hidden relative") do
          render MapControls.new
          turbo_frame(id: "place_being_viewed", class: "relative transition h-0")
        end
        @places.map do |place|
          turbo_frame(id: "place_#{place.id}", class: "marker hidden", data_food: place.has_food, data_brewery: place.is_brewery, data_shop: place.is_shop) do
            a(href: helpers.place_path(place), data_lng: place.lng, data_lat: place.lat, data_id: place.id, data_turbo_frame: "place_being_viewed")
          end
        end
        div(class: "w-[32px] h-[32px] hidden", data_map_target: "userLocation", id: "user-location-element") do
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
