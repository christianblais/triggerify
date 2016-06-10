module Handlers
  class GiftCard < Base
    setting :value
    setting :note
    setting :customer_id

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
