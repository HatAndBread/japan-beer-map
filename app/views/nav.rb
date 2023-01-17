module Views
  class Nav < Phlex::HTML
    register_element :turbo_frame

    def template
      nav(class: "bg-white shadow", data_controller: "nav") do
        div(class: "mx-auto max-w-7xl px-2 sm:px-6 lg:px-8") do
          div(class: "relative flex h-16 justify-between") do
            div(class: "absolute inset-y-0 left-0 flex items-center sm:hidden") do
              button(type: "button", class: "inline-flex items-center justify-center rounded-md p-2 text-gray-400 hover:bg-gray-100 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500", aria_controls: "mobile-menu", aria_expanded: "false", data_action: "click->nav#toggleNav", data_nav_target: "hamburger") do
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
                nav_links
              end
            end
            div(class: "absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0") do
              render Views::LanguageSwitcher.new
              div(class: "relative ml-3") do
                div do
                  button(type: "button", class: "flex rounded-full bg-white text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2", id: "user-menu-button", aria_expanded: "false", aria_haspopup: "true", data_action: "click->nav#toggleMenu", data_nav_target: "avatar") do
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
        div(class: "hidden md:hidden", id: "mobile-menu", data_nav_target: "dropdown") do
          mobile_nav_links
        end
      end
    end

    private

    def admin? = helpers.current_user&.admin?

    def nav_links
      a(href: helpers.root_path, class: (helpers.current_page?(helpers.root_path) || helpers.current_page?("/")) ? current_page_link_class : other_page_link_class) { helpers.t("home") }
      a(href: helpers.map_path, class: (helpers.current_page?(helpers.map_path) || helpers.current_page?("/map")) ? current_page_link_class : other_page_link_class) { helpers.t("map") }
      a(href: helpers.new_place_path, class: helpers.current_page?(helpers.new_place_path) ? current_page_link_class : other_page_link_class) { helpers.t("nav.new_place") }
      a(href: helpers.visits_path, class: helpers.current_page?(helpers.visits_path) ? current_page_link_class : other_page_link_class) { helpers.t("nav.visits") }
      a(href: helpers.admin_path, class: helpers.current_page?(helpers.admin_path) ? current_page_link_class : other_page_link_class) { "Admin" } if admin?
    end

    def mobile_nav_links
      div(class: "space-y-1 pt-2 pb-4") do
        a(href: helpers.root_path, class: (helpers.current_page?(helpers.root_path) || helpers.current_page?("/")) ? mobile_current_page_link_class : mobile_other_page_link_class) { helpers.t("home") }
        a(href: helpers.map_path, class: (helpers.current_page?(helpers.map_path) || helpers.current_page?("/map")) ? mobile_current_page_link_class : mobile_other_page_link_class) { helpers.t("map") }
        a(href: helpers.new_place_path, class: helpers.current_page?(helpers.new_place_path) ? mobile_current_page_link_class : mobile_other_page_link_class) { helpers.t("nav.new_place") }
        a(href: helpers.visits_path, class: helpers.current_page?(helpers.visits_path) ? mobile_current_page_link_class : mobile_other_page_link_class) { helpers.t("nav.visits") }
        a(href: helpers.admin_path, class: helpers.current_page?(helpers.admin_path) ? mobile_current_page_link_class : mobile_other_page_link_class) { "Admin" } if admin?
      end
    end

    def current_page_link_class
      "inline-flex items-center border-b-2 border-indigo-500 px-1 pt-1 text-sm font-medium text-gray-900"
    end

    def other_page_link_class
      "inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
    end

    def mobile_current_page_link_class
      "block border-l-4 border-indigo-500 bg-indigo-50 py-2 pl-3 pr-4 text-base font-medium text-indigo-700"
    end

    def mobile_other_page_link_class
      "block border-l-4 border-transparent py-2 pl-3 pr-4 text-base font-medium text-gray-500 hover:border-gray-300 hover:bg-gray-50 hover:text-gray-700"
    end
  end
end
