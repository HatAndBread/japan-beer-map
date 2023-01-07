module Views
  class Pages::Home < Phlex::HTML
    include ApplicationView

    def template
      render Layout.new(title: "Pages Home") do
        div(class: "") do
          h1 { "👋 Hello World!" }
        end
      end
    end
  end
end

