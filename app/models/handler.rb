class Handler < ActiveRecord::Base
  HANDLERS = [
    Handlers::Tagger,
    Handlers::DatadogEvent,
    Handlers::Slack,
    Handlers::SMS,
    Handlers::Twitter,
    Handlers::Emailer,
    Handlers::SendGrid,
  ]

  belongs_to :rule, inverse_of: :handlers

  validates :rule, presence: true
  validates :service_name, presence: true, inclusion: HANDLERS.map(&:to_s)

  serialize :settings, Hash

  def service
    service_name.constantize
  end

  def handle(payload)
    service.new(settings, payload).call
  end
end
