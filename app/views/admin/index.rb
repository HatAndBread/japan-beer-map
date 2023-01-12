module Views
  class Admin::Index < Phlex::HTML
    include ApplicationView

    def template
      div(class: "") do
        h1 { "This is admin!" }

        places.map do |place|
          place.to_json
        end
      end
    end

    private

    def places
      @places ||= Place.needs_approval
    end
  end
end
