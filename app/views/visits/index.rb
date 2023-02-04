module Views
  class Visits::Index < Phlex::HTML
    include ApplicationView

    register_element :turbo_frame

    def initialize(visits:)
      @visits = visits
    end

    def template
      div(class: "p-4 sm:p8 lg:p-16 2xl:p-24") do
        div(class: "font-semibold text-lg") do
          (I18n.locale == :en) ?
            "You have visited #{unique_visits} out of #{place_count} #{(place_count == 1) ? "place" : "places"}" :
            "#{unique_visits}か所中#{place_count}か所を訪れました"
        end
        a(class: "link-primary", href: helpers.race_path) { helpers.t("leader_board_link") }
        ul(role: "list", class: "divide-y divide-gray-200") do
          if @visits.size.positive?
            @visits.map do |visit|
              li(class: "flex py-4") do
                img(
                  class: "h-10 w-10 rounded-full",
                  src: helpers.avatar_for_place(visit.place),
                  alt: ""
                )
                div(class: "ml-3") do
                  p(class: "text-sm font-medium text-gray-900") { visit.place.name }
                  p(class: "text-sm text-gray-500") { Time.now.to_fs(:short) }
                end
              end
            end
          else
            li(class: "mt-4") { "It looks like you haven't checked into any places yet." }
          end
        end
      end
    end

    private

    def unique_visits
      @visits.map { |v| v[:place_id] }.uniq.size
    end

    def place_count
      @place_count ||= Place.cached_count
    end
  end
end
