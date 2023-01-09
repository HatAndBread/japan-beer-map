module Views
  class LanguageSwitcher < Phlex::HTML
    def template
      nav(class: "flex") do
        language_link
      end
    end

    private

    def language_link
      (I18n.locale == :ja) ?
        a(href: helpers.url_for(locale: :en), class: "border border-solid") { img(src: helpers.image_path("en.svg"), height: "30", width: "30") } :
        a(href: helpers.url_for(locale: :ja), class: "border border-solid") { img(src: helpers.image_path("jp.svg"), height: "30", width: "30") }
    end
  end
end
