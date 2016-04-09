class Handler < ActiveRecord::Base
  HANDLERS = [
    Handlers::Emailer,
    Handlers::Tagger
  ]

  belongs_to :rule

  serialize :settings

  def settings
    super || {}
  end
end
