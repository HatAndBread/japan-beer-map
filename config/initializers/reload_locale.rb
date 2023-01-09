if Rails.env == "development"
  locale_reloader = ActiveSupport::FileUpdateChecker.new(Dir["config/locales/*yml"]) do
    I18n.backend.reload!
  end

  ActiveSupport::Reloader.to_prepare do
    locale_reloader.execute_if_updated
  end
end
