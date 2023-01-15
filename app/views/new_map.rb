module Views
  class NewMap < Phlex::HTML
    register_element :turbo_frame

    def template
      div(data_controller: "new-map", data_action: "new-map:lngLat->place-new#lngLat", class: "w-full h-[300px]") do
      end
    end
  end
end
