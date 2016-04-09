class ApplicationController < ActionController::Base
  include ShopifyApp::LoginProtection
  protect_from_forgery with: :exception

  protected

  def shop
    @shop ||= Shop.find(session[:shopify])
  rescue ActiveRecord::RecordNotFound
    nil
  end
  helper_method :shop
end
