module Handlers
  class GiftCard < Base
    setting :value

    def call
      return if value.blank?

      gift_card = ShopifyAPI::GiftCard.new
      gift_card.value = value
      gift_card.save
      Rails.logger.info("GIFT_CARD: #{gift_card} : #{gift_card.errors}")
    end
  end
end
