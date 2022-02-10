require_relative 'handler_error'

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

  LAST_ERRORS_COUNT = 5

  belongs_to :rule, inverse_of: :handlers

  validates :rule, presence: true
  validates :service_name, presence: true, inclusion: HANDLERS.map(&:to_s)
  validate :validate_settings

  serialize :settings, Hash
  serialize :last_errors, Array

  def service
    service_name.constantize
  end

  def handle(payload)
    begin
      service.new(settings, payload).call
    rescue StandardError => error
      last_error = HandlerError.new(message: error.message, timestamp: Time.now.utc)
      self.last_errors = self.last_errors.append(last_error).last(LAST_ERRORS_COUNT)
      save!(validate: false)
    end

    Handler.increment_counter(:handle_count, id, touch: true)
  end

  private

  def validate_settings
    return if service.settings.keys.all? { settings[_1].present? }

    errors.add(:settings, :blank)
  end
end
