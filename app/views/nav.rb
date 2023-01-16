module Views
  class Nav < Phlex::HTML
    register_element :turbo_frame

    def template
      nav(class: "bg-white shadow", data_controller: "nav") do
        div(class: "mx-auto max-w-7xl px-2 sm:px-6 lg:px-8") do
          div(class: "relative flex h-16 justify-between") do
            div(class: "absolute inset-y-0 left-0 flex items-center sm:hidden") do
              button(type: "button", class: "inline-flex items-center justify-center rounded-md p-2 text-gray-400 hover:bg-gray-100 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500", aria_controls: "mobile-menu", aria_expanded: "false") do
                span(class: "sr-only") { "Open main menu" }
                svg(class: "block h-6 w-6", xmlns: "http://www.w3.org/2000/svg", fill: "none", viewbox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor", aria_hidden: "true") do
                  path stroke_linecap: "round", stroke_linejoin: "round", d: "M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"
                end
                svg(class: "hidden h-6 w-6", xmlns: "http://www.w3.org/2000/svg", fill: "none", viewbox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor", aria_hidden: "true") do
                  path stroke_linecap: "round", stroke_linejoin: "round", d: "M6 18L18 6M6 6l12 12"
                end
              end
            end
            div(class: "flex flex-1 items-center justify-center sm:items-stretch sm:justify-start") do
              div(class: "flex flex-shrink-0 items-center") do
                img class: "block h-8 w-auto lg:hidden rounded-full", src: helpers.image_path("bg.png"), alt: "Japan Craft Beer Adventures"
                img class: "hidden h-8 w-auto lg:block rounded-full", src: helpers.image_path("bg.png"), alt: "Japan Craft Beer Adventures"
              end
              div(class: "hidden sm:ml-6 sm:flex sm:space-x-8") do
                a(href: helpers.root_path, class: "inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700") { helpers.t("home") }
                a(href: helpers.new_place_path, class: "inline-flex items-center border-b-2 border-indigo-500 px-1 pt-1 text-sm font-medium text-gray-900") { helpers.t("nav.new_place") }
                a(href: helpers.visits_path, class: "inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700") { helpers.t("nav.visits") }
                a(href: helpers.admin_path, class: "inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700") { "Admin" } if admin?
                div(class: "inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700") do
                  render Views::LanguageSwitcher.new
                end
              end
            end
            div(class: "absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0") do
              button(type: "button", class: "rounded-full bg-white p-1 text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2") do
                span(class: "sr-only") { "View notifications" }
                svg(class: "h-6 w-6", xmlns: "http://www.w3.org/2000/svg", fill: "none", viewbox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor", aria_hidden: "true") do
                  path stroke_linecap: "round", stroke_linejoin: "round", d: "M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0"
                end
              end
              div(class: "relative ml-3") do
                div do
                  button(type: "button", class: "flex rounded-full bg-white text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2", id: "user-menu-button", aria_expanded: "false", aria_haspopup: "true", data_action: "click->nav#openMenu", data_nav_target: "avatar") do
                    span(class: "sr-only") { "Open user menu" }
                    img class: "h-8 w-8 rounded-full", src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: ""
                  end
                end
                div(class: "absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none hidden", role: "menu", aria_orientation: "vertical", aria_labelledby: "user-menu-button", tabindex: "-1", data_nav_target: "menu") do
                  if helpers.current_user
                  a(href: "#", class: "block px-4 py-2 text-sm text-gray-700 hover:bg-indigo-50 flex items-center justify-between", role: "menuitem", tabindex: "-1", id: "user-menu-item-0") do
                    span { "Your Profile" }
                    i(class: "las la-tools")
                  end
                    a(class: "block px-4 py-2 text-sm text-gray-700 hover:bg-indigo-50 flex items-center justify-between", href: helpers.destroy_user_session_path, data_turbo_method: :delete) do
                      span { helpers.t("nav.sign_out") }
                      i(class: "las la-sign-out-alt")
                    end
                  else
                    a(class: "block px-4 py-2 text-sm text-gray-700 hover:bg-indigo-50 flex items-center justify-between", href: helpers.new_user_session_path) do
                      span { helpers.t("nav.sign_in") }
                      i(class: "las la-sign-in-alt")
                    end
                    a(class: "block px-4 py-2 text-sm text-gray-700 hover:bg-indigo-50 flex items-center justify-between", href: helpers.new_user_registration_path) do
                      span { helpers.t("nav.sign_up") }
                      i(class: "las la-beer")
                    end
                  end
                end
              end
            end
          end
        end
        div(class: "sm:hidden", id: "mobile-menu") do
          div(class: "space-y-1 pt-2 pb-4") do
            a(href: helpers.root_path, class: "block border-l-4 border-transparent py-2 pl-3 pr-4 text-base font-medium text-gray-500 hover:border-gray-300 hover:bg-gray-50 hover:text-gray-700") { helpers.t("home") }
            a(href: helpers.new_place_path, class: "block border-l-4 border-indigo-500 bg-indigo-50 py-2 pl-3 pr-4 text-base font-medium text-indigo-700") { helpers.t("nav.new_place") }
            a(href: helpers.visits_path, class: "block border-l-4 border-transparent py-2 pl-3 pr-4 text-base font-medium text-gray-500 hover:border-gray-300 hover:bg-gray-50 hover:text-gray-700") { helpers.t("nav.visits") }
            a(href: helpers.admin_path, class: "block border-l-4 border-transparent py-2 pl-3 pr-4 text-base font-medium text-gray-500 hover:border-gray-300 hover:bg-gray-50 hover:text-gray-700") { "Admin" } if admin?
          end
        end
      end
    end

    private

    def admin? = helpers.current_user&.admin?
  end
end
