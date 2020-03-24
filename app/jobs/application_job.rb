class ApplicationJob < ActiveJob::Base
  queue_as :default

  rescue_from(StandardError) do |exception|
    Bugsnag.notify(exception) do |report|
      report.add_tab(:payload, arguments.first)
    end
  end
end
