class Handler < ActiveRecord::Base
  HANDLERS = {
    Handlers::Tagger => 'Add a tag to a Shopify resource',
    Handlers::DatadogEvent => 'Send a Datadog event',
    Handlers::Slack => 'Send a message on Slack',
    Handlers::SMS => 'Send a SMS (via Twillio)',
    Handlers::Twitter => 'Send a tweet',
    Handlers::Emailer => 'Send an email (Test only)',
    Handlers::SendGrid => 'Send an email (via SendGrid)',
  }

  belongs_to :rule, inverse_of: :handlers

  validates :rule, presence: true
  validates :service_name, presence: true, inclusion: HANDLERS.keys.map(&:to_s)

  serialize :settings, Hash

  def service
    service_name.constantize
  end

  def handle(payload)
    service.new(settings, payload).call
  end
end
