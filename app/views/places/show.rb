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
        div(class: "relative top-0 w-full h-full z-20 bg-indigo-50 overflow-scroll animate__animated animate__zoomIn", data_controller: "place-show", data_action: "place-show:checkin->map#updateUserLocation", data_place: @place.to_json) do
          div(class: "w-full flex justify-end") do
            button(class: "text-4xl text-indigo-600 hover:text-indigo-800 pt-2 pr-2 transition", title: "close", data_action: "click->place-show#close") do
              i(class: "las la-window-close")
            end
          end
          div(class: "bg-red-100 text-red-600 hidden", data_place_show_target: "tooFar") { helpers.t("place.show.too_far") }
          turbo_frame(id: "visit") do
            form_with(model: Visit.new(place: @place), class: "hidden") do |f|
              f.text_field(:place_id, readonly: "readonly")
              f.submit(data: {place_show_target: "visit"})
            end
          end
          button(class: "btn-primary", data_action: "click->place-show#checkin") { helpers.t("place.show.check_in") }
          div(class: "flex flex-col max-w-[1000px] mx-auto w-full lg:p-[64px] p-[32px]") do
            div(class: "flex items-center lg:items-start flex-col lg:flex-row") do
              div(class: "lg:w-[50%]") do
                render "shared/carousel", images: @place.photos.map { |p| helpers.cl_image_path(p.key, height: 300, width: 400, crop: :fill) } + @place.google_photos
              end
              div(class: "lg:w-full") do
                h1(class: "text-4xl font-bold tracking-tight text-gray-900 sm:text-5xl md:text-6xl lg:text-5xl xl:text-6xl w-full flex justify-center") do
                  span(class: "block xl:inline text-center") { @place.name }
                end
                ul(class: "flex w-full justify-around mt-[24px]") do
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
                if @place.website
                  a(class: "inline-flex items-center font-medium text-indigo-600 hover:underline text-lg", href: @place.website, target: "_blank") do
                    text "Website"
                    svg(aria_hidden: "true", class: "w-5 h-5 ml-1", fill: "currentColor", viewbox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg") do
                      path fill_rule: "evenodd", d: "M12.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-2.293-2.293a1 1 0 010-1.414z", clip_rule: "evenodd"
                    end
                  end
                end
              end
            end
            render Views::Reviews.new(reviews: @place.reviews)
          end
        end
      end
    end
  end
end
