class Rule < ActiveRecord::Base
  TOPICS = %w(
    orders/create
  )

  belongs_to :shop
  has_many :handlers, dependent: :destroy

  validates :name, presence: true
  validates :topic, presence: true, inclusion: TOPICS
end
