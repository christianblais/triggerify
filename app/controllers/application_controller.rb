class ApplicationController < ActionController::Base
  protected

  def shop
    @shop_record ||= Shop.where(shopify_domain: current_shopify_session.domain).first
  rescue ActiveRecord::RecordNotFound
    nil
  end
  helper_method :shop
end
