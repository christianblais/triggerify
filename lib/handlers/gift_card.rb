module Handlers
  class GiftCard < Base
    description %(
      This requires your shop to be on the Plus Shopify plan.
      <a href="https://www.shopify.ca/plus">Learn more</a>.
    )

    setting :value,
      name: 'Value of the gift card',
      example: '5.00'

    setting :note,
      name: 'Note of the gift card',
      example: 'Created by triggerify'

    setting :customer_id,
      name: 'ID of the customer',
      optional: true,
      example: '{{ customer_id }}'

    def call
      raise(UserError, "Missing 'value'") if value.blank?

      gift_card = ShopifyAPI::GiftCard.new
      gift_card.initial_value = value
      gift_card.note = note
      gift_card.customer_id = customer_id
      gift_card.save
    end
  end
end
