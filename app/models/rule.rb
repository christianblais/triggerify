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
    'draft_orders/create' => 'Draft order creation',
    'draft_orders/delete' => 'Draft order deletion',
    'draft_orders/update' => 'Draft order update',
    'fulfillments/create' => 'Fulfillment creation',
    'fulfillments/update' => 'Fulfillment update',
    'fulfillment_events/create' => 'Fulfillment event creation',
    'fulfillment_events/delete' => 'Fulfillment event deletion',
    'inventory_items/create' => 'Inventory item creation',
    'inventory_items/delete' => 'Inventory item deletion',
    'inventory_items/update' => 'Inventory item update',
    'inventory_levels/connect' => 'Inventory level connection',
    'inventory_levels/disconnect' => 'Inventory level disconnection',
    'inventory_levels/update' => 'Inventory level update',
    'locations/create' => 'Location creation',
    'locations/delete' => 'Location deletion',
    'locations/update' => 'Location update',
    'orders/cancelled' => 'Order cancellation',
    'orders/create' => 'Order creation',
    'orders/delete' => 'Order deletion',
    'orders/fulfilled' => 'Order fulfillment',
    'orders/paid' => 'Order payment',
    'orders/updated' => 'Order update',
    'order_transactions/create' => 'Order transaction creation',
    'products/create' => 'Product creation',
    'products/delete' => 'Product deletion',
    'products/update' => 'Product update',
    'refunds/create' => 'Refund create',
    'shop/update' => 'Shop update',
    'themes/publish' => 'Theme publish',
  }

  belongs_to :shop
  has_many :filters, dependent: :destroy, inverse_of: :rule
  has_many :handlers, dependent: :destroy, inverse_of: :rule

  validates :name, presence: true
  validates :topic, presence: true, inclusion: TOPICS.keys

  accepts_nested_attributes_for :handlers, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :filters, allow_destroy: true, reject_if: :all_blank

  scope :enabled, -> { where(enabled: true) }
end
