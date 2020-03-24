class CallbackController < ApplicationController
  include ShopifyApp::WebhookVerification

  def webhook
    CallbackWebhookJob.perform_later(
      shop_domain: shop.shopify_domain,
      callback: params[:callback].to_unsafe_h,
      topic: params[:topic]
    )

    head :ok
  rescue => e
    Bugsnag.notify(e)
    head :ok
  end

  def receive
    CallbackWebhookJob.perform_later(
      shop_domain: request.headers.fetch('X-Shopify-Shop-Domain'),
      callback: params.fetch(:callback).to_unsafe_h,
      topic: request.headers.fetch('X-Shopify-Topic')
    )

    head :ok
  rescue => e
    Bugsnag.notify(e)
    head :ok
  end

  private

  def shop
    @shop ||= Shop.find(params[:shop_id])
  end
end
