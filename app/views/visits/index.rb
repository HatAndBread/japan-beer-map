module Views
  class Visits::Index < Phlex::HTML
    include ApplicationView

    register_element :turbo_frame

    def initialize(visits:)
      @visits = visits
    end

    def template
      div do
        ul(role: "list", class: "divide-y divide-gray-200") do
          @visits.map do |visit|
            li(class: "flex py-4") do
              img(
                class: "h-10 w-10 rounded-full",
                src: helpers.avatar_for_place(visit.place),
                alt: ""
              )
              div(class: "ml-3") do
                p(class: "text-sm font-medium text-gray-900") { visit.place.name }
                p(class: "text-sm text-gray-500") { Time.now.to_fs(:short) }
              end
            end
          end
        end
      end
    end
  end
end
