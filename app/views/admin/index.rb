module Views
  class Admin::Index < Phlex::HTML
    include ApplicationView

    def template
      div(class: "") do
        h1 { "This is admin!" }
      end
    end
  end
end
