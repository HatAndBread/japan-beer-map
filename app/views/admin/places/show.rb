module Views
  class Admin::Places::Show < Phlex::HTML
    include Phlex::Rails::Helpers::FormWith
    include ApplicationView

    register_element :turbo_frame

    def initialize(place:)
      @place = place
    end

    def template
      turbo_frame(id: "place_#{@place.id}") do
        if @place.approved
          p { "Place already approved. No action needs to be taken." }
        else
          div(class: "", data_controller: "place-show", data_place: @place.to_json) do
            h1(class: "") { @place.name }
            pre do
              code(class: ""){ JSON.pretty_generate(@place.attributes) }
            end
            div(class: "bg-slate-800 text-slate-100 rounded p-2 flex flex-col items-center") do
              h1 { "ADMIN" }
              div(class: "flex justify-center") do
                a(class: "m-2 underline", href: helpers.admin_place_path(@place, place: {approved: true}), data_turbo_method: :patch) { "Approve" }
                a(class: "m-2 underline", href: helpers.admin_place_path(@place), data_turbo_method: :delete) { "Delete" }
              end
            end
          end
        end
      end
    end
  end
end
