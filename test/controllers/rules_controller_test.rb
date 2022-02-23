require 'test_helper'

class RulesControllerTest < ActionController::TestCase
  setup do
    shop = shops(:regular_shop)

    request.env['jwt.shopify_domain'] = shop.shopify_domain
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
    get :new, params: { template: RuleTemplate.all.first }
    assert_response :success
  end

  test "show" do
    rule = rules(:email)

    get :show, params: { id: rule.id }
    assert_response :success
  end

  test "create" do
    assert_difference('Rule.count', 1) do
      attributes = {
        name: "Test",
        enabled: 1,
        topic: "carts/update"
      }

      post :create, params: { rule: attributes }
    end
  end

  test "create invalid rule" do
    assert_difference('Rule.count', 0) do
      attributes = {
        name: "",
        enabled: 1,
        topic: ""
      }

      post :create, params: { rule: attributes }
    end

    assert_match "Oops, there was an error", flash[:error]
  end

  test "update" do
    rule = rules(:email)

    attributes = {
      name: "This is a test",
    }

    post :update, params: { id: rule.id, rule: attributes }

    assert_equal "This is a test", rule.reload.name
  end

  test "update invalid rule" do
    rule = rules(:email)

    attributes = {
      name: "",
    }

    post :update, params: { id: rule.id, rule: attributes }

    assert_equal "Email on customer creation from Canada", rule.reload.name

    assert_match "Oops, there was an error", flash[:error]
  end

  test "destroy" do
    assert_difference('Rule.count', -1) do
      rule = rules(:email)

      post :destroy, params: { id: rule.id }
    end
  end
end
