class WebhookCreationJob < ApplicationJob
  def perform(shop_domain:, topic:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    manager = ShopifyApp::WebhooksManager.new(shop.shopify_domain, shop.shopify_token)
    manager.create_webhook(topic: topic, address: 'bla bla bla')
  rescue ShopifyApp:WebhooksManager::CreationFailed
    Rails.logger.info('Oops, something went wrong!')
  end
end
