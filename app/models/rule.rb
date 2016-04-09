class Rule < ActiveRecord::Base
  TOPICS = %w(
    orders/create
  )

  belongs_to :shop

  validates :topic, presence: true, inclusion: TOPICS
end
