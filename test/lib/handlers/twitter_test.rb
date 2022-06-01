require 'test_helper'

module Handlers
  class TwitterTest < ActiveSupport::TestCase
    test '#call' do
      handler = build_handler

      mock_config = mock
      mock_config.expects(:consumer_key=).with("test_consumer_key")
      mock_config.expects(:consumer_secret=).with("test_consumer_secret")
      mock_config.expects(:access_token=).with("test_access_token")
      mock_config.expects(:access_token_secret=).with("test_access_token_secret")

      mock_client = mock
      ::Twitter::REST::Client
        .expects(:new)
        .yields(mock_config)
        .returns(mock_client)

      mock_client.expects(:update).with("Test message")

      handler.call
    end

    private

    def build_handler(consumer_key: "test_consumer_key", consumer_secret: "test_consumer_secret", access_token: "test_access_token", access_token_secret: "test_access_token_secret", message: "Test message")
      settings = {
        consumer_key: consumer_key,
        consumer_secret: consumer_secret,
        access_token: access_token,
        access_token_secret: access_token_secret,
        message: message,
      }

      shop = shops(:regular_shop)
      Twitter.new(shop, settings, {})
    end
  end
end
