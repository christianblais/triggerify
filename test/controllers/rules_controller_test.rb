require 'test_helper'

class RulesControllerTest < ActionController::TestCase
  setup do
    shop = shops(:regular_shop)

    request.env['rack.url_scheme'] = 'https'
    @request.session[:shopify] = shop.id
    @request.session[:shopify_domain] = shop.shopify_domain
  end

  test "index" do
    get :index
    assert_response :success
  end

  test "new" do
    rule = rules(:email)

    get :new
    assert_response :success
  end

  test "show" do
    rule = rules(:email)

    get :show, params: { id: rule.id }
    assert_response :success
  end

  test "create" do
    skip
  end

  test "update" do
    skip
  end

  test "destroy" do
    skip
  end
end
