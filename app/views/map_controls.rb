module Views
  class MapControls < Phlex::HTML
    register_element :turbo_frame

    def template
      div(class: "w-[200px] flex flex-col gap-2 rounded p-2 border border-indigo-400 z-50 absolute bg-indigo-50 top-2 right-2") do
        button(data_map_target: "findMe", data_action: "click->map#findMe", class: "btn-primary w-full justify-center") do
          div(class: "hidden") do
            div(class: "loader")
          end
          span(class: "") do
            text(helpers.t("map_controls.my_location"))
          end
        end
        button(data_map_target: "nearestBeer", data_action: "click->map#nearestBeer", class: "btn-primary w-full justify-center") do
          div(class: "hidden") do
            div(class: "loader")
          end
          span(class: "") do
            helpers.t("map_controls.nearest_beer")
          end
        end
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
        input(type: "checkbox", checked: true, data_type: type, class: "cursor-pointer h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500 mr-2")
        label(for: "#{type}-box", class: "select-none font-medium text-gray-700 text-sm") { type.humanize }
      end
    end
  end
end
