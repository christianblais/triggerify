class Handler < ActiveRecord::Base
  HANDLERS = {
    Handlers::SendGrid => 'Send an email using the SendGrid API',
    Handlers::Emailer => 'Send an email (Test only)',
    Handlers::Tagger => 'Add a tag to a Shopify resource',
    Handlers::SMS => 'Send a SMS',
    Handlers::Slack => 'Send a message on Slack',
    Handlers::Twitter => 'Send a tweet',
    Handlers::DatadogEvent => 'Send a datadog event',
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
