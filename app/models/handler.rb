class Handler < ActiveRecord::Base
  HANDLERS = [
    Handlers::Emailer,
    Handlers::Tagger
  ]

  belongs_to :rule

  validates :rule, presence: true
  validates :service_name, presence: true, inclusion: HANDLERS.map(&:to_s)

  serialize :settings

  def settings
    super || {}
  end

  def service
    service_name.constantize
  end
end
