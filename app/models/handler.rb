class Handler < ActiveRecord::Base
  HANDLERS = [
    Handlers::Emailer,
    Handlers::Tagger,
    Handlers::SMS,
  ]

  belongs_to :rule, inverse_of: :handlers

  validates :rule, presence: true
  validates :service_name, presence: true, inclusion: HANDLERS.map(&:to_s)

  serialize :settings

  def settings
    super || {}
  end

  def service
    service_name.constantize
  end

  def handle(payload)
    service.new(settings, payload).call
  end
end
