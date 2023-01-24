module Views
  class Reviews < Phlex::HTML
    def initialize(place:)
      @place = place
    end

    def template
      div(class: "mt-4") do
        h2(class: "sr-only") { "Customer Reviews" }
        div(id: "the-comment") do
          render "shared/comment_box", review: Review.new unless @place.reviewed_by?(helpers.current_user)
        end
        div(class: "-my-10") do
          @place.reviews.map do |review|
            render Views::Reviews::Show.new(review:)
          end
        end
      end
    end
  end
end
