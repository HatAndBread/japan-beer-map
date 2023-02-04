module Views
  class Race < Phlex::HTML
    register_element :turbo_frame

    def initialize(race:)
      @race = race
    end

    def template
      turbo_frame(id: "the-race", class: "w-full p-8 sm:p-16") do
        h1(class: "w-full text-3xl text-center font-bold mb-8") { helpers.t("leader_board") }
        div(class: "w-full") do
          ul(class: "flex flex-col gap-2") do
            @race.map do |data|
              user = data[:user]
              unique_visits = data[:unique_visits]
              li(class: "flex") do
                div(class: "flex flex-col items-center text-xs") do
                  img(class: "rounded-full w-16", src: helpers.avatar_for_user(user))
                  span(class: "") { (user.username || helpers.t("anonymous")).truncate(10) }
                end
                div(class: "w-full h-16 bg-gray-200 rounded overflow-hidden text-center") do
                  span { "#{unique_visits} / #{place_count}" }
                  div(class: "h-full float-left bg-indigo-400", style: "width: #{(unique_visits.to_i / place_count.to_f * 100).to_i}%")
                end
              end
            end
          end
        end
      end
    end

    private

    def place_count
      @place_count ||= Place.cached_count
    end
  end
end
