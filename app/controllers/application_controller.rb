class ApplicationController < ActionController::Base
  around_action :switch_locale

  def switch_locale(&action)
    update_preferred_locale
    extract_locale_from_accept_language_header
    locale = current_user.try(:locale) || params[:locale] || http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options = {locale: I18n.locale}

  protected

  def authenticate_admin!
    authenticate_user!
    redirect_to root_path, status: :forbidden unless current_user.admin?
  end

  private

  def extract_locale_from_accept_language_header
    request.env["HTTP_ACCEPT_LANGUAGE"].scan(/^[a-z]{2}/).first
  end

  def update_preferred_locale
    return unless params[:locale].in?([:en, :ja, "en", "ja"]) && current_user && current_user.locale != params[:locale]

    current_user.update(locale: params[:locale])
  end
end
