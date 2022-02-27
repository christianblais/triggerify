require 'test_helper'

class CallbackWebhookJobTest < ActiveSupport::TestCase
  setup do
    @job = CallbackWebhookJob.new
    @shop = shops(:regular_shop)
  end

  test "#perform" do
    callback = {
      "id" => "1234",
      "email" => "test@example.com",
      "country" => "Canada",
    }

    mock_runner = mock
    mock_runner.expects(:perform)
    RuleRunner
      .expects(:new)
      .with(rule: @shop.rules.first, callback: callback)
      .returns(mock_runner)

    @job.perform(
      shop_domain: @shop.shopify_domain,
      topic: "customers/create",
      callback: callback,
    )
  end
end
