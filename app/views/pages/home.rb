module Views
  class Pages::Home < Phlex::HTML
    include ApplicationView

    def template
      div(class: "") do
        h1 { "👋 Hello World!" }
      end
    end
  end
end
