module Views
  class MapControls < Phlex::HTML
    register_element :turbo_frame

    def template
      div(class: "") do
        form(data_action: "change->controls#change", data_controller: "controls") do
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
