require 'test_helper'

module Handlers
  class GiftCardTest < ActiveSupport::TestCase
    test '#call' do
      handler = build_handler

      mock_api = mock
      mock_api.expects(:initial_value=).with("10.00")
      mock_api.expects(:note=).with("VIP customer")
      mock_api.expects(:customer_id=).with("1234")
      mock_api.expects(:save)

      ShopifyAPI::GiftCard.expects(:new).returns(mock_api)

      handler.call
    end

    private

    def build_handler(value: "10.00", note: "VIP customer", customer_id: "1234")
      settings = {
        value: value,
        note: note,
        customer_id: customer_id,
      }

      GiftCard.new(settings, {})
    end
  end
end
