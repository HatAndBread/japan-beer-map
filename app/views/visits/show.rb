module Views
  class Visits::Show < Phlex::HTML
    include ApplicationView

    register_element :turbo_frame

    def initialize(visits:)
      @visits = visits
    end

    def template
      div do
        "My Visits!"
      end
    end
  end
end
