module Views
  class Places::Show < Phlex::HTML
    include Phlex::Rails::Helpers::FormWith
    include ApplicationView

    register_element :turbo_frame

    def initialize(place:)
      @place = place
    end

    def template
      turbo_frame(id: "place_being_viewed") do
        div(class: "", data_controller: "place-show", data_place: @place.to_json) do
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
        if admin?
          div(class: "bg-slate-800 text-slate-100 rounded p-2 flex flex-col items-center") do
            h1 { "ADMIN" }
            div(class: "flex justify-center") do
              a(class: "m-2 underline", href: helpers.admin_place_path(@place, place: {approved: true}), data_turbo_method: :patch) { "Approve" }
              a(class: "m-2 underline", href: helpers.admin_place_path(@place), data_turbo_method: :delete) { "Approve" }
            end
          end
        end
      end
    end

    def admin?
      helpers.current_user&.admin? && helpers.controller.class.name.split("::").first == "Admin"
    end
  end
end
