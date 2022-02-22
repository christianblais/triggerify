class Handler < ActiveRecord::Base
  EVENTS_TO_KEEP = 10

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
  serialize :events, Array

  def service
    service_name.constantize
  end

  def handle(payload)
    instance = service.new(settings, payload)

    begin
      instance.call

      record_event(status: HandlerEvent::STATUS_SUCCESS, message: "Successful")
    rescue Handlers::UserError => e
      Rails.logger.info("User error: #{e.message}")

      record_event(status: HandlerEvent::STATUS_ERROR, message: e.message)
    end

    Handler.increment_counter(:handle_count, id, touch: true)
  end

  private

  def validate_settings
    return if service.settings.keys.all? { settings[_1].present? }

    errors.add(:settings, :blank)
  end

  def record_event(status:, message:)
    event = HandlerEvent.new(status: status, message: message, timestamp: Time.now.utc)
    self.events = self.events.append(event).last(EVENTS_TO_KEEP)
    save!(validate: false)
  end
end
