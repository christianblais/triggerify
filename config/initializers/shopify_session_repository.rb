if Rails.configuration.cache_classes
  ShopifyApp::SessionRepository.shop_storage = Shop
else
  ActiveSupport::Reloader.to_prepare do
    ShopifyApp::SessionRepository.shop_storage = Shop
  end
end
