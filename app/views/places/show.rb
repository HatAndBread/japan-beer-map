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
        div(class: "relative top-0 w-full h-full z-20 bg-gray-50 border-t border-t-indigo-200 overflow-scroll animate__animated animate__zoomIn", data_controller: "place-show", data_place: @place.to_json) do
          div(class: "w-full flex justify-end") do
            button(class: "text-4xl text-indigo-600 hover:text-indigo-800 pt-2 pr-2 transition", title: "close", data_action: "click->place-show#close") do
              i(class: "las la-window-close")
            end
          end
          div(class: "flex flex-col w-[90%] max-w-[1000px] mx-auto w-full lg:p-[64px] p-[32px] border border-indigo-200 bg-white rounded-lg") do
            div(class: "w-full flex justify-end") do
              a(class: "mb-2 text-indigo-600 hover:text-idigo-800 hover:underline transition text-lg", href: helpers.place_place_updates_path(@place)) { "Update Info" }
            end
            div(class: "flex items-center lg:items-start flex-col lg:flex-row w-full") do
              div(class: "w-full relative") do
                div(class: "w-full flex justify-center") do
                  render "shared/carousel", images: (@place.photos.empty? && @place.google_photos.empty?) ? [helpers.image_path("bg.png")] : @place.photos.map { |p| helpers.cl_image_path(p.key, height: 300, width: 400, crop: :fill) } + @place.google_photos
                  div(data_place_show_target: "fileInput", class: "hidden w-full max-w-[400px]") do
                    form_with(model: @place) do |f|
                      f.file_field :photos, accept: "image/*", as: :file, multiple: true, class: "hidden", data: {file_target: "input", place_show_target: "input"}
                      render "shared/file_input"
                      div(class: "w-full flex justify-end mt-4") do
                        f.button helpers.t("cancel"), class: "btn-secondary mr-4", data: { action: "click->place-show#hideFileInput" }
                        f.submit helpers.t("save"), class: "btn-primary", data: { action: "click->place-show#saveFile" }
                      end
                    end
                  end
                end
              end
              # Business type
              div(class: "w-full lg:p-2 flex flex-col items-start mt-4") do
                h1(class: "text-4xl font-bold tracking-tight text-gray-900 sm:text-5xl md:text-6xl lg:text-5xl xl:text-6xl w-full flex justify-center") do
                  span(class: "block xl:inline text-center") { @place.name }
                end
                ul(class: "flex w-full justify-around items-center mt-[8px] text-gray-500 shadow rounded-lg border h-[2em]") do
                  li(class: "flex border-r w-full h-full items-center justify-center whitespace-nowrap") do
                    div(class: "mr-2") { "#{helpers.t("place.show.bottle_shop")}: " }
                    @place.is_shop? ? img(src: helpers.image_path("ok.svg"), width: 16, height: 16) : img(src: helpers.image_path("no.svg"), width: 16)
                  end
                  li(class: "flex border-r w-full h-full items-center justify-center whitespace-nowrap") do
                    div(class: "mr-2") { "#{helpers.t("place.show.brewery")}: " }
                    @place.is_brewery? ? img(src: helpers.image_path("ok.svg"), width: 16, height: 16) : img(src: helpers.image_path("no.svg"), width: 16)
                  end
                  li(class: "flex w-full h-full items-center justify-center whitespace-nowrap") do
                    div(class: "mr-2") { "#{helpers.t("place.show.has_food")}: " }
                    @place.has_food? ? img(src: helpers.image_path("ok.svg"), width: 16, height: 16) : img(src: helpers.image_path("no.svg"), width: 16)
                  end
                end
              end
            end
            div(class: "flex flex-col lg:flex-row lg:gap-4") do
              div(class: "w-full") do
                # Check in
                div(class: "mt-4 flex flex-col gap-4") do
                  div(class: "bg-red-100 text-red-600 hidden p-2 rounded", data_place_show_target: "tooFar") { helpers.t("place.show.too_far") }
                  turbo_frame(id: "visit") do
                    form_with(model: Visit.new(place: @place), class: "hidden") do |f|
                      f.text_field(:place_id, readonly: "readonly")
                      f.submit(data: {place_show_target: "visit"})
                    end
                  end
                  button(class: "inline-flex items-center font-medium text-indigo-600 hover:underline w-fit", data_action: "click->place-show#checkin") { helpers.t("place.show.check_in") }
                  # Website
                  if @place.website
                    div(class: "") do
                      a(class: "inline-flex items-center font-medium text-indigo-600 hover:underline", href: @place.website, target: "_blank") do
                        text "Website"
                        svg(aria_hidden: "true", class: "w-5 h-5 ml-1", fill: "currentColor", viewbox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg") do
                          path fill_rule: "evenodd", d: "M12.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-2.293-2.293a1 1 0 010-1.414z", clip_rule: "evenodd"
                        end
                      end
                    end
                  end
                  # Directions
                  div(class: "flex flex-col gap-2") do
                    div(class: "text-gray-500 underline") { "Get Directions" }
                    span(class: "isolate inline-flex rounded-md") do
                      button(title: "Walk there", class: "relative inline-flex items-center rounded-l-md border border-gray-300 bg-white px-4 py-2 text-xl font-medium text-gray-700 hover:bg-gray-50 focus:z-10 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500", data_action: "click->place-show#takeMeThere", data_type: "walking") { i(class: "las la-walking") }
                      button(title: "Bike there", class: "relative -ml-px inline-flex items-center border border-gray-300 bg-white px-4 py-2 text-xl font-medium text-gray-700 hover:bg-gray-50 focus:z-10 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500", data_action: "click->place-show#takeMeThere", data_type: "cycling") { i(class: "las la-bicycle") }
                      button(title: "Drive there", class: "relative -ml-px inline-flex items-center border border-gray-300 bg-white px-4 py-2 text-xl font-medium text-gray-700 hover:bg-gray-50 focus:z-10 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500", data_action: "click->place-show#takeMeThere", data_type: "driving") { i(class: "las la-car") }
                      button(title: "Use Google Maps", class: "relative -ml-px inline-flex items-center rounded-r-md border border-gray-300 bg-white px-4 py-2 text-xl font-medium text-gray-700 hover:bg-gray-50 focus:z-10 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500", data_action: "click->place-show#takeMeThereWithGoogle") { i(class: "lab la-google") }
                    end
                  end
                end
                # Time-table
                ul(role: "list", class: "divide-y divide-gray-200 text-gray-600 lg:w-full w-[300px]") do
                  7.times do |n|
                    li(class: "py-4 flex justify-between w-full") do
                      span(class: "font-semibold") { days[n] }
                      div do
                        span(class: "mr-1") { @place.open_time_for_day(n) }
                        span(class: "mr-1") { "-" }
                        span(class: "") { @place.close_time_for_day(n) }
                      end
                    end
                  end
                end
              end
              div(class: "w-full") do
                render Views::Reviews.new(place: @place)
              end
            end
          end
        end
      end
    end

    private

    def days
      [helpers.t("sunday"), helpers.t("monday"), helpers.t("tuesday"), helpers.t("wednesday"), helpers.t("thurday"), helpers.t("friday"), helpers.t("saturday")]
    end
  end
end
