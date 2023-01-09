module Views
  class Places::Show < Phlex::HTML
    include ApplicationView

    register_element :turbo_frame

    def initialize(place:)
      @place = place
    end

    def template
      turbo_frame(id: "place_being_viewed") do
        div(class: "") do
          h1(class: "") { @place.name }
          ul do
            li(class: "flex") do
              text "#{helpers.t("place.show.bottle_shop")}: "
              @place.is_shop? ? img(src: helpers.image_path("ok.svg"), width: 24) : img(src: helpers.image_path("no.svg"), width: 24)
            end
            li(class: "flex") do
              text "#{helpers.t("place.show.brewery")}: "
              @place.is_brewery? ? img(src: helpers.image_path("ok.svg"), width: 24) : img(src: helpers.image_path("no.svg"), width: 24)
            end
            li(class: "flex") do
              text "#{helpers.t("place.show.has_food")}: "
              @place.has_food? ? img(src: helpers.image_path("ok.svg"), width: 24) : img(src: helpers.image_path("no.svg"), width: 24)
            end
          end
          a(href: @place.website, target: "_blank") { "Website" } if @place.website
        end
      end
    end
  end
end
