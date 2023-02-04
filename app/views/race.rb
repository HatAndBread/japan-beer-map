module Views
  class Race < Phlex::HTML
    def initialize(race:)
      @race = race
    end

    def template
      nav(class: "flex") do
        language_link
      end
    end
  end
end
