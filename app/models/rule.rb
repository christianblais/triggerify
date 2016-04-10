class Rule < ActiveRecord::Base
  TOPICS = %w(
    orders/create
  )

  belongs_to :shop
  has_many :handlers, dependent: :destroy

  validates :name, presence: true
  validates :topic, presence: true, inclusion: TOPICS

  accepts_nested_attributes_for :handlers

  after_commit :register_webhook

  private

  def register_webhook
    WebhookCreationJob.queue(shop_domain: shop.shopify_domain, topic: topic)
  end
end
