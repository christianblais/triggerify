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

    Handlers::Emailer.any_instance.expects(:call)

    @job.perform(
      shop_domain: @shop.shopify_domain,
      topic: "customers/create",
      callback: callback,
    )
  end
end
