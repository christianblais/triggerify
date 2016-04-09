class Handler < ActiveRecord::Base
  HANDLERS = [
    Handlers::Tagger
  ]

  belongs_to :rule

  serialize :settings
end
