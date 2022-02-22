require 'test_helper'

module Handlers
  class SmsTest < ActiveSupport::TestCase
    test '#call' do
      handler = build_handler

      mock_client = mock
      Twilio::REST::Client
        .expects(:new)
        .with("test_sid", "test_auth_token")
        .returns(mock_client)

      mock_message = mock
      mock_client
        .expects(:messages)
        .returns(mock_message)

      mock_message
        .expects(:create)
        .with(from: "555-555-1111", to: "555-555-9999", body: "Test message")

      handler.call
    end

    test '#call with known error' do
      handler = build_handler

      mock_client = mock
      Twilio::REST::Client
        .expects(:new)
        .with("test_sid", "test_auth_token")
        .returns(mock_client)

      mock_message = mock
      mock_client
        .expects(:messages)
        .returns(mock_message)

      mock_response = stub(status_code: 20404, body: {})
      error = Twilio::REST::RestError.new("Error message", mock_response)
      mock_message
        .expects(:create)
        .with(from: "555-555-1111", to: "555-555-9999", body: "Test message")
        .raises(error)

      e = assert_raise(UserError) do
        handler.call
      end
      assert_equal e.message, "Twillio error: [HTTP 20404] 20404 : Error message"
    end

    private

    def build_handler(twilio_account_sid: "test_sid", twilio_auth_token: "test_auth_token", twilio_from_phone_number: "555-555-1111", phone_number: "555-555-9999", message: "Test message")
      settings = {
        twilio_account_sid: twilio_account_sid,
        twilio_auth_token: twilio_auth_token,
        twilio_from_phone_number: twilio_from_phone_number,
        phone_number: phone_number,
        message: message,
      }

      SMS.new(settings, {})
    end
  end
end
