module Views
  class Places::New < Phlex::HTML
    include Phlex::Rails::Helpers::FormWith
    include ApplicationView

    register_element :turbo_frame

    def initialize
      @place = Place.new
    end

    def template
      div(class: "flex flex-col items-center w-full text-sm") do
        div(class: "max-w-[800px] w-[90%] border border-grey-200 p-8 rounded mb-8 bg-white mt-[32px]", data_controller: "place-new") do
          p(class: "leading-relaxed") do
            div(class: "mb-4") do
              b { "Thank you " }
              text "for contributing to this project. There are a few steps you need to complete in order to a new business to this map."
            end
            ol(class: "") do
              li(class: "mb-2") { "① Set the location of the business by clicking on it's location on the map. Please be as accuraate as possible." }
              li(class: "mb-2") { '② Fill in as much information about the business as you can. If you don\'t know everything that\'s OK! "Name" is the only mandatory parameter.' }
              li(class: "mb-2") { "③ Add any images you have available of the business." }
              li(class: "mb-2") { "④ Our admins review every new submission to avoid spam. We will try to approve your submission within 1 day." }
            end
          end
          div(class: "mt-8") do
            render Views::NewMap.new
          end
          div(class: "bg-red-100 text-red-600", data_place_new_target: "notCompleted") { "Location not yet set." }
          div(class: "bg-green-100 text-green-600 hidden", data_place_new_target: "completed") { "Location successfully added." }
          form_with model: @place, class: "mt-8", data: {action: "submit->place-new#handleSubmit"} do |f|
            # website
            div(class: "mb-4") do
              label(for: "name", class: "block text-sm font-medium text-gray-700") { "Name Of Business" }
              div(class: "mt-1") do
                f.text_field :name, id: "name", placeholder: "Example Store", class: "block w-full border-gray-300 rounded-md shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm", data: {place_new_target: "placeName"}
              end
            end
            # website
            div(class: "mb-4") do
              div(class: "flex justify-between") do
                label(for: "website", class: "block text-sm font-medium text-gray-700") { "Website" }
                span(class: "text-sm text-gray-500") { "Optional" }
              end
              div(class: "relative mt-1 rounded-md shadow-sm") do
                div(class: "absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none") do
                  span(class: "text-gray-500") { "http://" }
                end
                f.text_field :website, id: "website", placeholder: "www.example.com", class: "block w-full pl-16 border-gray-300 rounded-md focus:border-indigo-500 focus:ring-indigo-500 sm:pl-14 sm:text-sm"
              end
            end
            # phone
            div(class: "mb-4") do
              div(class: "flex justify-between") do
                label(for: "phone", class: "block text-sm font-medium text-gray-700") { "Phone" }
                span(class: "text-sm text-gray-500") { "Optional" }
              end
              div(class: "mt-1") do
                f.text_field :phone, id: "phone", placeholder: "090-1111-1111", class: "block w-full border-gray-300 rounded-md shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
              end
            end
            # types
            fieldset(class: "border-t border-b border-gray-200 mb-4") do
              div(class: "divide-y divide-gray-200") do
                div(class: "relative flex items-start py-4") do
                  div(class: "min-w-0 flex-1 text-sm") do
                    label(for: "is_brewery", class: "font-medium text-gray-700") { "Brewery" }
                    p(id: "comments-description", class: "text-gray-500") do
                      "This business brews and sells beer on location."
                    end
                  end
                  div(class: "ml-3 flex h-5 items-center") do
                    input id: "is_brewery", aria_describedby: "is_brewery-description", type: "checkbox", class: "h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
                  end
                end
                div(class: "relative flex items-start py-4") do
                  div(class: "min-w-0 flex-1 text-sm") do
                    label(for: "is_shop", class: "font-medium text-gray-700") { "Bottle Shop" }
                    p(id: "is_shop-description", class: "text-gray-500") do
                      "This business sells bottles or cans of beer."
                    end
                  end
                  div(class: "ml-3 flex h-5 items-center") do
                    input id: "is_shop", aria_describedby: "is_shop-description", type: "checkbox", class: "h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
                  end
                end
                div(class: "relative flex items-start py-4") do
                  div(class: "min-w-0 flex-1 text-sm") do
                    label(for: "has_food", class: "font-medium text-gray-700") { "Food" }
                    p(id: "has_food-description", class: "text-gray-500") do
                      "This business serves food or is a restuarant."
                    end
                  end
                  div(class: "ml-3 flex h-5 items-center") do
                    input id: "has_food", aria_describedby: "has_food-description", type: "checkbox", class: "h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
                  end
                end
              end
            end
            # times
            div(class: "mb-4") do
              div(class: "min-w-0 flex-1 text-sm") do
                div(class: "flex justify-between") do
                  span(class: "font-medium text-gray-700") { "Hours" }
                  span(class: "text-sm text-gray-500") { "Optional" }
                end
                p(id: "has_food-description", class: "text-gray-500") do
                  "If possible please enter operating hours for this business."
                end
              end
              div(class: "grid grid-cols-1 divide-y divide-gray-200") do
                days.map.with_index do |day, idx|
                  div(class: "mt-2") do
                    span(class: "text-sm font-medium text-gray-700") { day }
                    div(class: "flex items-center") do
                      div(class: "relative") do
                        input name: "start", class: "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full pl-10 p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500", placeholder: "Select #{day} start", type: :time, id: "#{idx}-start"
                      end
                      span(class: "mx-4 text-gray-500") { "to" }
                      div(class: "relative") do
                        input name: "end", class: "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full pl-10 p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500", placeholder: "Select #{day} end", type: :time, id: "#{idx}-end"
                      end
                    end
                  end
                end
              end
            end
            f.text_field :lng, id: :lng, class: "hidden", data: {place_new_target: "lng"}
            f.text_field :lat, id: :lat, class: "hidden", data: {place_new_target: "lat"}
            f.text_field :periods, id: :periods, class: "hidden", data: {place_new_target: "periods"}
            f.file_field :photos, accept: "image/*", as: :file, multiple: true, class: "hidden", data: {file_target: "input"}
            div(class: "flex justify-between") do
              span(class: "block text-sm font-medium text-gray-700") { "Images" }
              span(class: "text-sm text-gray-500") { "Optional" }
            end
            render("shared/file_input", f:)
            button(class: "btn-large mt-8 w-[120px] justify-center", type: "submit", name: "button", data_place_new_target: "submitButton") do
              div(class: "", data_place_new_target: "submitButtonText") { helpers.t("save") }
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
