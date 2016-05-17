class Rule < ActiveRecord::Base
  TOPICS = %w(
    orders/create
    customers/create
  )

  belongs_to :shop
  has_many :handlers, dependent: :destroy, inverse_of: :rule

  validates :name, presence: true
  validates :topic, presence: true, inclusion: TOPICS

  accepts_nested_attributes_for :handlers
end
