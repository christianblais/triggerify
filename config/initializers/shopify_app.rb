ShopifyApp.configure do |config|
  config.application_name = "Triggerify"
  config.old_secret = ""
  config.scope = "write_orders, write_products, write_customers, write_fulfillments, write_themes, write_inventory"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.api_version = "unstable"
  config.shop_session_repository = 'Shop'

  config.reauth_on_access_scope_changes = true

  config.allow_jwt_authentication = true
  config.allow_cookie_authentication = false

  config.api_key = ENV['SHOPIFY_CLIENT_API_KEY'].presence || raise("Missing SHOPIFY_CLIENT_API_KEY env variable")
  config.secret = ENV['SHOPIFY_CLIENT_API_SECRET'].presence || raise("Missing SHOPIFY_CLIENT_API_SECRET env variable")
end
