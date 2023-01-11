module Views
  class Nav < Phlex::HTML
    def template
      nav(class: "flex") do
        a(href: helpers.root_path) { helpers.t("nav.home") }
        a(href: helpers.new_user_session_path) { helpers.t("nav.sign_in") } unless helpers.current_user
        a(href: helpers.new_user_registration_path) { helpers.t("nav.sign_up") } unless helpers.current_user
        a(href: helpers.new_place_path) { helpers.t("nav.new_place") }
        render "shared/button_to", text: helpers.t("nav.sign_out"), method: :delete, path: helpers.destroy_user_session_path if helpers.current_user
        render Views::LanguageSwitcher.new
      end
    end
  end
end
