module Views
  class Pages::Home < Phlex::HTML
    include ApplicationView

    def template
      div(class: "") do
        h1 { helpers.t(:hello) }
        render Views::Map.new
      end
    end
  end
end
