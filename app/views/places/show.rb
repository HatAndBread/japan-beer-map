module Views
  class Places::Show < Phlex::HTML
    include Phlex::Rails::Helpers::FormWith
    include ApplicationView

    register_element :turbo_frame

    def initialize(place:)
      @place = place
    end

    def template
      turbo_frame(id: "place_being_viewed", class: "relative") do
        div(class: "relative top-0 w-screen h-screen z-50", data_controller: "place-show", data_action: "place-show:checkin->map#updateUserLocation", data_place: @place.to_json) do
          div(class: "w-full flex justify-end") do
            button(class: "text-4xl text-indigo-800 pt-2 pr-2", title: "close", data_action: "click->place-show#close") do
              i(class: "las la-window-close")
            end
          end
          h1(class: "") { @place.name }
          div(class: "bg-red-100 text-red-600 hidden", data_place_show_target: "tooFar") { helpers.t("place.show.too_far") }
          turbo_frame(id: "visit") do
            form_with(model: Visit.new(place: @place), class: "hidden") do |f|
              f.text_field(:place_id, readonly: "readonly")
              f.submit(data: {place_show_target: "visit"})
            end
          end
          button(class: "", data_action: "click->place-show#checkin") { helpers.t("place.show.check_in") }
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
