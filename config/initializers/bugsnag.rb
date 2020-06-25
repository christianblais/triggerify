Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_API_KEY'].presence

  config.app_version = ENV['HEROKU_SLUG_COMMIT']
end

module BugsnagConsole
  def notify(e, auto_notify = false)
    Rails.logger.error("Exception reported to Bugsnag:")
    Rails.logger.error("#{e.class}: #{e.message}")
    e.backtrace.each do |line|
      Rails.logger.error(" #{line}")
    end

    super
  end
end
Bugsnag.singleton_class.prepend(BugsnagConsole)
