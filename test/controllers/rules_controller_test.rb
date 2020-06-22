require 'test_helper'

class RulesControllerTest < ActionController::TestCase
  setup do
    shop = shops(:regular_shop)

    request.env['rack.url_scheme'] = 'https'
    @request.session[:shop_id] = shop.id
    @request.session[:shopify_domain] = shop.shopify_domain
  end

  test "index" do
    get :index
    assert_response :success
  end

  test "templates" do
    get :templates
    assert_response :success
  end

  test "new" do
    get :new
    assert_response :success
  end

  test "new with templates" do
    get :new, params: { template: RuleTemplate.all.keys.first }
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
