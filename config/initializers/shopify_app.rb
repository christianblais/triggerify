ShopifyApp.configure do |config|
  config.application_name = "Triggerify"
  config.api_key = ENV['SHOPIFY_CLIENT_API_KEY']
  config.secret = ENV['SHOPIFY_CLIENT_API_SECRET']
  config.old_secret = ""
  config.scope = "write_orders, write_products, write_customers, write_fulfillments, write_themes"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.api_version = "unstable"
  config.session_repository = Shop
end
