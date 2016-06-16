module Handlers
  class GiftCard < Base
    setting :value,
      info: 'Value of the gift card',
      example: '5.00'

    setting :note,
      info: 'Note of the gift card',
      example: 'Here is a small gift to thank you for your first purchase with us. Enjoy!'

    setting :customer_id,
      info: 'ID of the customer for which it will be created',
      example: '{{ customer_id }}'

    def call
      return if value.blank?

      gift_card = ShopifyAPI::GiftCard.new
      gift_card.initial_value = value
      gift_card.note = note
      gift_card.customer_id = customer_id
      gift_card.save
    end
  end
end
