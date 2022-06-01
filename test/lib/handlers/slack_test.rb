require 'test_helper'

module Handlers
  class SlackTest < ActiveSupport::TestCase
    test '#call' do
      handler = build_handler

      mock_client = mock
      ::Slack::Web::Client
        .expects(:new)
        .with(token: "test_token")
        .returns(mock_client)
      mock_client
        .expects(:chat_postMessage)
        .with(channel: "#test", text: "Test message")

      handler.call
    end

    test '#call too many requests error' do
      handler = build_handler

      mock_client = mock
      ::Slack::Web::Client
        .expects(:new)
        .with(token: "test_token")
        .returns(mock_client)
      mock_response = mock(headers: { 'retry-after' => 60 })
      mock_client
        .expects(:chat_postMessage)
        .with(channel: "#test", text: "Test message")
        .raises(::Slack::Web::Api::Errors::TooManyRequestsError, mock_response)

      e = assert_raises(UserError) do
        handler.call
      end
      assert_equal(e.message, "Unable to send Slack message. Slack replied with the following message: Retry after 60 seconds")
    end

    private

    def build_handler(slack_token: "test_token", channel: "#test", message: "Test message")
      settings = {
        slack_token: slack_token,
        channel: channel,
        message: message,
      }

      shop = shops(:regular_shop)
      Slack.new(shops, settings, {})
    end
  end
end
