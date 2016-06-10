module Handlers
  class GiftCard < Base
    setting :value

    def call
      return if value.blank?

      gift_card = ShopifyAPI::GiftCard.new
      gift_card.value = value
      gift_card.save
    end
  end
end
