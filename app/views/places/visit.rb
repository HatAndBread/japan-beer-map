module Views
  class Places::Visit < Phlex::HTML
    include ApplicationView

    register_element :turbo_frame

    def initialize(visit:)
      @visit = visit
    end

    def template
      turbo_frame(id: "visit") do
        div(class: "") do
          div(class: "bg-green-100 text-green-600", data_place_show_target: "saved") { helpers.t("place.show.saved") }
          div { "You have visited this location #{@visit.visit_count} times" }
          text(@visit.to_json)
        end
      end
    end
  end
end
