module Views
  class Layout < Phlex::HTML
    include ApplicationView
    include Phlex::Rails::Layout

    def initialize(title:)
      @title = title
    end

    def template(&)
      doctype

      html do
        head do
          meta charset: "utf-8"
          csp_meta_tag
          csrf_meta_tags
          meta name: "viewport", content: "width=device-width,initial-scale=1"
          title { @title }
          stylesheet_link_tag "tailwind", "inter-font", "data-turbo-track": "reload"
          stylesheet_link_tag "application", "data-turbo-track": "reload"
          javascript_importmap_tags
        end

        body(class: "flex flex-col md:flex-row") do
          p(class: "notice", id: "the-notice") { helpers.notice }
          p(class: "alert", id: "the-alert") { helpers.alert }
          render Nav.new
          main(&)
        end
      end
    end
  end
end

