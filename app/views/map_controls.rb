module Views
  class MapControls < Phlex::HTML
    register_element :turbo_frame

    def template
      div(class: "w-fit rounded p-2 border border-indigo-400 z-50 absolute bg-indigo-50 top-2 left-2", data_map_target: "toolsWrapper") do
        div(data_map_target: "toolsOpener", class: "hidden") do
          button(class: "las la-map-marked-alt border rounded text-indigo-600 text-3xl hover:text-indigo-800 transition", data_action: "click->map#openTools")
        end
        div(data_map_target: "toolsContainer", class: "") do
          div(class: "flex justify-end") do
            button(class: "text-2xl text-indigo-600 hover:text-indigo-800 w-fit transition", data_action: "click->map#closeTools") { i(class: "las la-window-close") }
          end
          div(id: "tools-content", class: "flex flex-col gap-2") do
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
