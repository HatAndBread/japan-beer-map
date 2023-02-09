module Views
  class Hero < Phlex::HTML
    register_element :turbo_frame

    def initialize(places:, geo_json:)
      @places = places
      @geo_json = geo_json
    end

    def template
      div(class: "relative bg-gray-50 w-screen lg:mb-[104px] border-t border-indigo-200") do
        div(class: "lg:relative") do
          div(class: "w-full pt-16 pb-20 text-center lg:text-left") do
            div(class: "lg:w-1/2  lg:flex lg:flex-col items-center px-8 lg:px-32") do
              h1(class: "text-4xl font-bold tracking-tight text-gray-900 sm:text-5xl md:text-6xl lg:text-5xl xl:text-6xl md:whitespace-nowrap") do
                span(class: "block xl:inline") { helpers.t("hello") }
              end
              img(class: "max-w-[300px] rounded-full mx-auto lg:mx-0 mt-8", src: helpers.image_path("bg.png"), alt: "logo")
              p(class: "mx-auto lg:mx-0 mt-3 max-w-md text-lg text-gray-500 sm:text-xl md:mt-5 md:max-w-3xl lg:w-[500px]") do
                text helpers.t("hero_start")
                if I18n.locale == :en
                  text helpers.t("hero_map")
                  a(class: "font-semibold hover:underline text-indigo-400 hover:text-indigo-600 cursor-pointer", href: helpers.map_path) { helpers.t("hero_map_link") }
                else
                  a(class: "font-semibold hover:underline text-indigo-400 hover:text-indigo-600 cursor-pointer", href: helpers.map_path) { helpers.t("hero_map_link") }
                  text helpers.t("hero_map")
                end
                text helpers.t("hero_race")
                a(class: "font-semibold hover:underline text-indigo-400 hover:text-indigo-600 cursor-pointer", href: helpers.race_path) { helpers.t("hero_race_link") }
                text helpers.t("hero_race_two")
              end
              div(class: "mt-10 sm:flex sm:justify-center lg:justify-start") do
                unless helpers.current_user
                  div(class: "rounded-md shadow") do
                    a(href: helpers.new_user_registration_path, class: "whitespace-nowrap flex w-full items-center justify-center rounded-md border border-transparent bg-indigo-600 px-8 py-3 text-base font-medium text-white hover:bg-indigo-700 md:py-4 md:px-10 md:text-lg") { helpers.t("sign-up") }
                  end
                  div(class: "mt-3 rounded-md shadow sm:mt-0 sm:ml-3") do
                    a(href: helpers.new_user_session_path, class: "whitespace-nowrap flex w-full items-center justify-center rounded-md border border-transparent bg-indigo-100 px-8 py-3 text-base font-medium hover:bg-gray-50 md:py-4 md:px-10 md:text-lg text-indigo-700 hover:bg-indigo-200 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2") { helpers.t("sign-in") }
                  end
                end
              end
            end
          end
          div(class: "relative h-fit w-full lg:absolute lg:inset-y-0 lg:right-0 lg:w-1/2") do
            render Views::Map.new(places: @places, geo_json: @geo_json)
          end
        end
      end
    end
  end
end
