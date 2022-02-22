require 'test_helper'

module Handlers
  class SendgridTest < ActiveSupport::TestCase
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

    test '#call unknown response code' do
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

      e = assert_raises(SendGrid::DeliveryError) do
        handler.call
      end
      assert_equal(e.message, "Error code: 500. Some error from the server")
    end

    test '#call unauthorized 401 error' do
      handler = build_handler

      mock_response = stub(
        status_code: 401,
        body: '{"errors":[{"message":"Authenticated user is not authorized to send mail","field":null,"help":null}]}',
        headers: {},
      )

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

      e = assert_raises(UserError) do
        handler.call
      end
      assert_equal(e.message, 'SendGrid error: 401. {"errors":[{"message":"Authenticated user is not authorized to send mail","field":null,"help":null}]}')
    end

    test '#call unverified 403 error' do
      handler = build_handler

      mock_response = stub(
        status_code: 403,
        body: '{"errors":[{"message":"The from address does not match a verified Sender Identity......","field":"from","help":null}]}',
        headers: {},
      )

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

      e = assert_raises(UserError) do
        handler.call
      end
      assert_equal(e.message, 'SendGrid error: 403. {"errors":[{"message":"The from address does not match a verified Sender Identity......","field":"from","help":null}]}')
    end

    private

    def build_handler(api_key: "test_api_key", from: "test_from@example.com", recipients: "test@example.com", subject: "email subject", body: "email body")
      settings = {
        api_key: api_key,
        from: from,
        recipients: recipients,
        subject: subject,
        body: body,
      }

      SendGrid.new(settings, {})
    end
  end
end
