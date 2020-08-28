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
  validate :validate_settings

  serialize :settings, Hash

  def service
    service_name.constantize
  end

  def handle(payload)
    service.new(settings, payload).call

    Handler.increment_counter(:handle_count, id, touch: true)
  end

  private

  def validate_settings
    return if service.settings.keys.all? { settings[_1].present? }

    errors.add(:settings, :blank)
  end
end
