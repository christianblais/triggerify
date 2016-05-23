class CallbackController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def webhook
    shop.with_shopify_session do
      shop.rules.where(topic: params[:topic]).each do |rule|
        rule.handlers.each do |handler|
          handler.handle(params[:callback])
        end
      end
    end
  end

  private

  def shop
    @shop ||= Shop.find(params[:shop_id])
  end
end
