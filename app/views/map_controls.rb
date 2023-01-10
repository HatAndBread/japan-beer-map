module Views
  class MapControls < Phlex::HTML
    register_element :turbo_frame

    def template
      div(class: "") do
        button(data_map_target: "findMe", data_action: "click->map#findMe") { helpers.t("map_controls.my_location") }
        button(data_map_target: "findMe", data_action: "click->map#nearestBeer") { helpers.t("map_controls.nearest_beer") }
        form(data_action: "change->map#handleChange") do
          %w[brewery food shop].map do |type|
            box(type)
          end
        end
      end
    end

    private

    def box(type)
      div(class: "", id: "#{type}-box", name: "#{type}-box") do
        input(type: "checkbox", checked: true, data_type: type)
        label(for: "#{type}-box") { type.humanize }
      end
    end
  end
end
