require 'test_helper'

module Handlers
  class EmailerTest < ActiveSupport::TestCase
    setup do
      ENV.stubs(:fetch).with("HANDLER_EMAILER_FROM").returns('test_from@example.com')
      ENV.stubs(:fetch).with("HANDLER_EMAILER_API_KEY").returns('test_api_key')
    end

    test '#call' do
      handler = build_handler

      mock_response = stub(status_code: 202, body: "success", headers: {})

      request_body = {
        "from" => { "email" => "test_from@example.com" },
        "subject" => "email subject",
        "personalizations" => [
          {
            "to" => [{ "email" => "test@example.com" }],
          }],
        "content" => [{"type" => "text/plain", "value" => "email body"}],
      }
      ::SendGrid::Client.any_instance.expects(:post).with(request_body: request_body).returns(mock_response)

      handler.call
    end

    test '#call with array destination' do
      handler = build_handler(recipients: "test1@example.com,test2@example.com,test3@example.com")

      mock_response = stub(status_code: 202, body: "success", headers: {})

      request_body = {
        "from" => { "email" => "test_from@example.com" },
        "subject" => "email subject",
        "personalizations" => [
          {
            "to" => [
              { "email" => "test1@example.com" },
              { "email" => "test2@example.com" },
              { "email" => "test3@example.com" },
            ],
          }],
        "content" => [{"type" => "text/plain", "value" => "email body"}],
      }
      ::SendGrid::Client.any_instance.expects(:post).with(request_body: request_body).returns(mock_response)

      handler.call
    end

    test '#call invalid response code' do
      handler = build_handler

      mock_response = stub(status_code: 500, body: "Some error from the server", headers: {})

      request_body = {
        "from" => { "email" => "test_from@example.com" },
        "subject" => "email subject",
        "personalizations" => [
          {
            "to" => [{ "email" => "test@example.com" }],
          }],
        "content" => [{"type" => "text/plain", "value" => "email body"}],
      }
      ::SendGrid::Client.any_instance.expects(:post).with(request_body: request_body).returns(mock_response)

      e = assert_raises(Emailer::DeliveryError) do
        handler.call
      end 
      assert_equal(e.message, "Error code: 500. Some error from the server")
    end

    test "#call with invalid recipients" do
      handler = build_handler(recipients: "example.com")

      e = assert_raises(UserError) do
        handler.call
      end
      assert_equal(e.message, 'email (example.com) is invalid')
    end

    private

    def build_handler(recipients: "test@example.com", subject: "email subject", body: "email body")
      settings = {
        recipients: recipients,
        subject: subject,
        body: body,
      }

      Emailer.new(settings, {})
    end
  end
end
