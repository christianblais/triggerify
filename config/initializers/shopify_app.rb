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

  credentials = Rails.application.credentials.fetch(:shopify)
  config.api_key = credentials.fetch(:client_api_key)
  config.secret = credentials.fetch(:client_api_secret)
end
