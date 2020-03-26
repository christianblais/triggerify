class ApplicationJob < ActiveJob::Base
  queue_as :default

  rescue_from(StandardError) do |exception|
    report_exception(exception)
  end

  private

  def report_exception(exception)
    Bugsnag.notify(exception) do |report|
      report.add_tab(:payload, arguments.first)

      yield(report) if block_given?
    end
  end
end
