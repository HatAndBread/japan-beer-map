module Views
  class HowItWorks < Phlex::HTML
    def template
      div(class: "w-full items-center justify-center flex flex-col md:flex-row max-w-[1200px] gap-4 lg:gap-8 md:px-8 mb-8") do
        div(class: card_class) do
          h1(class: "w-full text-center font-semibold text-xl my-4") do
            a(class: "hover:underline hover:text-indigo-600 text-indigo-400", href: helpers.map_path) { "Map" }
          end
          a(href: helpers.map_path) do
            img(class: "h-[200px] w-[200px] rounded-lg object-cover mx-auto", src: helpers.image_path("map-preview.png"))
          end
          p(class: "text-gray-500 text-center mt-8") do
            helpers.t("map_how_to")
          end
        end
        div(class: card_class) do
          h1(class: "w-full text-center font-semibold text-xl my-4") do
            a(class: "hover:underline hover:text-indigo-600 text-indigo-400", href: helpers.visits_path) { "Keep Track" }
          end
          a(href: helpers.visits_path) do
            img(class: "h-[200px] w-[200px] rounded-lg object-cover mx-auto", src: helpers.image_path("construction.png"))
          end
          p(class: "text-gray-500 text-center mt-8") do
            helpers.t("track_how_to")
          end
        end
        div(class: card_class) do
          h1(class: "w-full text-center font-semibold text-xl my-4") do
            a(class: "hover:underline hover:text-indigo-600 text-indigo-400", href: helpers.visits_path) { "Race" }
          end
          a(href: helpers.map_path) do
            img(class: "h-[200px] w-[200px] rounded-lg object-cover mx-auto", src: helpers.image_path("construction.png"))
          end
          p(class: "text-gray-500 text-center mt-8") do
            helpers.t("race_how_to")
          end
        end
      end
    end

    private

    def card_class
      "w-[90%] max-w-[300px] lg:w-[30%] shadow rounded h-[400px] border border-gray-100 bg-white p-8 flex flex-col"
    end
  end
end
