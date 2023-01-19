module Views
  class Reviews::Show < Phlex::HTML
    register_element :turbo_frame

    def initialize(review:)
      @review = review
    end

    def template
      div(class: "flex space-x-4 text-sm text-gray-500") do
        div(class: "flex-none py-10") do
          img src: helpers.avatar_for_user(@review.user), alt: "", class: "h-10 w-10 rounded-full bg-gray-100"
        end
        div(class: "flex-1 py-10") do
          h3(class: "font-medium text-gray-900") { @review.user.username || "Anonymous" }
          p do
            time(datetime: @review.time.to_date.to_fs(:db)) { @review.time.to_s(:long) }
          end
          div(class: "mt-4 flex items-center") do
            @review.rating.to_i.times { star("text-yellow-400") }
            (5 - @review.rating.to_i).times { star("text-slate-400") }
          end
          div(class: "prose prose-sm mt-4 max-w-none text-gray-500") do
            p(class: "whitespace-pre-wrap") { @review.text }
          end
        end
      end
    end

    private

    def star(color)
      svg(class: "#{color} h-5 w-5 flex-shrink-0", xmlns: "http://www.w3.org/2000/svg", viewbox: "0 0 20 20", fill: "currentColor", aria_hidden: "true") do
        path fill_rule: "evenodd", d: "M10.868 2.884c-.321-.772-1.415-.772-1.736 0l-1.83 4.401-4.753.381c-.833.067-1.171 1.107-.536 1.651l3.62 3.102-1.106 4.637c-.194.813.691 1.456 1.405 1.02L10 15.591l4.069 2.485c.713.436 1.598-.207 1.404-1.02l-1.106-4.637 3.62-3.102c.635-.544.297-1.584-.536-1.65l-4.752-.382-1.831-4.401z", clip_rule: "evenodd"
      end
    end
  end
end
