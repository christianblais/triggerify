class ShopJob < ApplicationJob
  def perform(shop_domain:, **args)
    @shop = Shop.find_by(shopify_domain: shop_domain)

    @shop.with_shopify_session do
      perform_with_shop(**args)
    end
  end

  private

  attr_reader :shop

  def perform_with_shop(*_args)
    raise NotImplementedError
  end
end
