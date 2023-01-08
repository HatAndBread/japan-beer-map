module Views
  class Nav < Phlex::HTML
    def template
      nav(class: "flex") do
        a(href: helpers.root_path) { "Home" }
        a(href: helpers.new_user_session_path) { "Sign In" }
        a(href: helpers.new_user_registration_path) { "Sign Up" }
        render "shared/button_to", text: "Log Out", method: :delete, path: helpers.destroy_user_session_path
      end
    end
  end
end
