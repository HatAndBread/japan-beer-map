module Views
  class Nav < Phlex::HTML
    def template
      nav(class: "flex") do
        a(href: helpers.root_path) { helpers.t("nav.home") }
        unless helpers.current_user
          a(href: helpers.new_user_session_path) do
            helpers.t("nav.sign_in")
            i(class: "las la-sign-in-alt")
          end
        end
        a(href: helpers.new_user_registration_path) { helpers.t("nav.sign_up") } unless helpers.current_user
        a(href: helpers.new_place_path) { helpers.t("nav.new_place") }
        a(href: helpers.admin_path) { "Admin" } if helpers.current_user&.admin?
        if helpers.current_user
          render "shared/button_to", text: helpers.t("nav.sign_out"), method: :delete, path: helpers.destroy_user_session_path
          a(class: "", href: helpers.destroy_user_session_path, data_turbo_method: :delete) do
            helpers.t("nav.sign_out")
            i(class: "las la-sign-out-alt")
          end
        end
        render Views::LanguageSwitcher.new
      end
    end
  end
end
