module Views
  class Admin::PlaceUpdates::Show < Phlex::HTML
    include Phlex::Rails::Helpers::FormWith
    include ApplicationView

    register_element :turbo_frame

    def initialize(update:)
      @update = update
    end

    def template
      div(class: "w-full") do
        h1(class: "text-3xl") { "Current" }
        pre do
          code(class: "max-w-screen"){ JSON.pretty_generate(@update.place.attributes) }
        end
        h1(class: "text-3xl") { "Proposed Change" }
        pre do
          code(class: "w-[100vw] overflow-scroll"){ JSON.pretty_generate(@update.attributes) }
        end
        div(class: "bg-slate-800 text-slate-100 rounded p-2 flex flex-col items-center") do
          div(class: "flex justify-center w-full") do
            a(href: helpers.place_place_updates_path(@update.place), class: "m-2 underline hover:text-indigo-400") { "Edit yourself" }
            a(href: helpers.admin_place_update_merge_path(@update), class: "m-2 underline hover:text-indigo-4o0") { "Merge" }
            a(href: helpers.admin_place_update_path(@update), data_turbo_method: :delete, class: "m-2 underline hover:text-indigo-3o0", confirm: "Are you sure you want to dismiss this update?") { "Dismiss" }
          end
        end
      end
    end
  end
end
