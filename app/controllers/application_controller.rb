class ApplicationController < ActionController::Base
  around_action :switch_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

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

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
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
