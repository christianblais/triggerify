require 'test_helper'

class RuleTest < ActiveSupport::TestCase
  setup do
    @shop = shops(:regular_shop)
    @rule = rules(:email)
  end

  test "create" do
    Rule.create!(
      name: 'Email on customer creation from Canada',
      shop: @shop,
      enabled: true,
      topic: 'customers/create',
    )
  end
end
