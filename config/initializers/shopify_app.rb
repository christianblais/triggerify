ShopifyApp.configure do |config|
  config.api_key = ENV['SHOPIFY_CLIENT_API_KEY']
  config.secret = ENV['SHOPIFY_CLIENT_API_SECRET']
  config.scope = "read_orders, read_products, write_customers"
  config.embedded_app = true
  config.webhooks = [
    {topic: 'app/uninstalled', address: 'https://triggerify.herokuapp.com/webhooks/app_uninstall', format: 'json'}
  ]
end
