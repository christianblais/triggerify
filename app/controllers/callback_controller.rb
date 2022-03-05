class CallbackController < ApplicationController
  include ShopifyApp::WebhookVerification

  def receive
    CallbackWebhookJob.perform_later(
      shop_domain: request.headers.fetch('X-Shopify-Shop-Domain'),
      callback: params.fetch(:callback).to_unsafe_h,
      topic: request.headers.fetch('X-Shopify-Topic'),
      shopify_identifier: request.headers.fetch('X-Shopify-Webhook-Id')
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
