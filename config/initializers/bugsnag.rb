Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_API_KEY'].presence
end
