module Views
  class NewMap < Phlex::HTML
    register_element :turbo_frame

    def template
      div(data_controller: "new-map", class: "w-[90vw] h-[800px]") do
      end
    end
  end
end
