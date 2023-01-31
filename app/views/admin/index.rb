module Views
  class Admin::Index < Phlex::HTML
    include ApplicationView
    register_element :turbo_frame

    def template
      div(class: "w-full flex flex-col gap-4 p-8") do
        h1(class: "text-3xl w-full text-center font-bold") { "Admin" }

        section(clas: "") do
          h1(class: "text-3xl underline") { "Places needing approval (#{places.count})" }
          ul(class: "flex flex-col") do
            places.map do |place|
              a(href: helpers.admin_place_path(place), class: "underline") { place.id }
            end
          end
          h1(class: "text-3xl underline") { "Updates needing review (#{place_updates.count})" }
          ul(class: "flex flex-col") do
            place_updates.map do |update|
              a(href: helpers.admin_place_update_path(update), class: "underline") { update.place.id }
            end
          end
        end
      end
    end

    private

    def places
      @places ||= Place.needs_approval
    end

    def place_updates
      @place_updates ||= PlaceUpdate.includes(:place).needs_review
    end
  end
end
