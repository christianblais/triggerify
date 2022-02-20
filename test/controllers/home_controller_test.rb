require 'test_helper'


class HomeControllerTest < ActionController::TestCase
  setup do
    @shop = shops(:regular_shop)

    auth_shop(@shop)
  end

  test "index" do
    get :index, params: { shop: @shop.shopify_domain }

    assert_response :success
  end

  private

  def auth_shop(shop)
    stubbed_session = ShopifyAPI::Session.new(
      domain: shop.shopify_domain,
      token: shop.shopify_token,
      api_version: shop.api_version,
      access_scopes: shop.access_scopes
    )

    ShopifyApp::SessionRepository
      .stubs(:retrieve_shop_session_by_shopify_domain)
      .with(shop.shopify_domain)
      .returns(stubbed_session)
  end
end
