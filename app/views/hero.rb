module Views
  class Hero < Phlex::HTML
    register_element :turbo_frame

    def template
      div(class: "relative bg-gray-50 w-screen mb-[104px] border-t border-indigo-200") do
        main(class: "lg:relative") do
          div(class: "mx-auto w-full max-w-7xl pt-16 pb-20 text-center lg:py-48 lg:text-left") do
            div(class: "px-6 sm:px-8 lg:w-1/2 xl:pr-16") do
              h1(class: "text-4xl font-bold tracking-tight text-gray-900 sm:text-5xl md:text-6xl lg:text-5xl xl:text-6xl") do
                span(class: "block xl:inline") { helpers.t("hello") }
              end
              p(class: "mx-auto mt-3 max-w-md text-lg text-gray-500 sm:text-xl md:mt-5 md:max-w-3xl") do
                "Anim aute id magna aliqua ad ad non deserunt sunt. Qui irure qui lorem cupidatat commodo. Elit sunt amet fugiat veniam occaecat fugiat aliqua."
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
                div(class: "mt-3 rounded-md shadow sm:mt-0 #{"sm:ml-3" unless helpers.current_user}") do
                  a(href: helpers.map_path, class: "whitespace-nowrap flex w-full items-center justify-center rounded-md border border-transparent bg-white px-8 py-3 text-base font-medium text-indigo-600 hover:bg-gray-50 md:py-4 md:px-10 md:text-lG") { "BEER MAP" }
                end
              end
            end
          end
          div(class: "relative h-64 w-full sm:h-72 md:h-96 lg:absolute lg:inset-y-0 lg:right-0 lg:h-full lg:w-1/2") do
            img class: "absolute inset-0 h-full w-full object-cover object-bottom w-[250px] h-[250px] mx-auto md:w-[400px] md:h-[400px] rounded-full lg:rounded-none lg:w-full lg:h-full", src: helpers.image_path("bg.png"), alt: ""
          end
        end
      end
    end
  end
end
