class Rule < ActiveRecord::Base
  TOPICS = {
    'carts/update' => 'Cart update',
    'checkouts/create' => 'Checkout creation',
    'checkouts/delete' => 'Checkout deletion',
    'checkouts/update' => 'Checkout update',
    'collections/create' => 'Collection creation',
    'collections/delete' => 'Collection deletion',
    'collections/update' => 'Collection update',
    'customer_groups/create' => 'Customer group creation',
    'customer_groups/delete' => 'Customer group deletion',
    'customer_groups/update' => 'Customer group update',
    'customers/create' => 'Customer creation',
    'customers/delete' => 'Customer deletion',
    'customers/disable' => 'Customer disable',
    'customers/enable' => 'Customer enable',
    'customers/update' => 'Customer update',
    'fulfillments/create' => 'Fulfillment creation',
    'fulfillments/update' => 'Fulfillment update',
    'orders/cancelled' => 'Order cancellation',
    'orders/create' => 'Order creation',
    'orders/delete' => 'Order deletion',
    'orders/fulfilled' => 'Order fulfillment',
    'orders/paid' => 'Order payment',
    'orders/updated' => 'Order update',
    'products/create' => 'Product creation',
    'products/delete' => 'Product deletion',
    'products/update' => 'Product update',
    'refunds/create' => 'Refund create',
    'shop/update' => 'Shop update',
    'themes/publish' => 'Theme publish',
  }

  belongs_to :shop
  has_many :handlers, dependent: :destroy, inverse_of: :rule

  validates :name, presence: true
  validates :topic, presence: true, inclusion: TOPICS.keys

  accepts_nested_attributes_for :handlers
end
