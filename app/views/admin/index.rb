module Views
  class Admin::Index < Phlex::HTML
    include ApplicationView
    register_element :turbo_frame

    def template
      div(class: "") do
        h1 { "Admin" }

        section do
          h1(class: "underline") { "Places needing approval (#{places.count})" }
          ul(class: "flex flex-col") do
            places.map do |place|
              turbo_frame(id: "place_being_viewed") do
                a(href: helpers.admin_place_path(place), class: "underline") { place.id }
              end
            end
          end
        end
      end
    end

    private

    def places
      @places ||= Place.needs_approval
    end
  end
end
