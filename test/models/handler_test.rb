require 'test_helper'

class HandlerTest < ActiveSupport::TestCase
  setup do
    ENV.stubs(:fetch).with("HANDLER_EMAILER_FROM").returns('test_from@example.com')
    ENV.stubs(:fetch).with("HANDLER_EMAILER_API_KEY").returns('test_api_key')
  end

  test "#handle" do
    handler = handlers(:email_deliver)

    payload = { id: "1234", email: "test@example.com" }

    mock_instance = mock
    mock_instance.expects(:call)

    Handlers::Emailer
      .expects(:new)
      .with(handler.settings, payload)
      .returns(mock_instance)

    handler.handle(payload)
  end

  test "#handle record success events" do
    handler = handlers(:email_deliver)
    payload = { id: "1234", email: "test@example.com" }

    Handlers::Emailer.any_instance.expects(:call)

    assert_difference(-> { handler.reload.events.length }, 1) do
      travel_to("2022-02-22 16:54:18 UTC") do
        handler.handle(payload)

        last_event = handler.events.last
        assert_equal(last_event.status, "success")
        assert_equal(last_event.message, "Successful")
        assert_equal(last_event.timestamp, "2022-02-22 16:54:18 UTC")
      end
    end
  end

  test "#handle record error events" do
    handler = handlers(:email_deliver)
    payload = { id: "1234", email: "test@example.com" }

    Handlers::Emailer.any_instance.expects(:call).raises(Handlers::UserError, "There was an error")

    assert_difference(-> { handler.reload.events.length }, 1) do
      travel_to("2022-02-22 16:54:18 UTC") do
        handler.handle(payload)

        last_event = handler.events.last
        assert_equal(last_event.status, "error")
        assert_equal(last_event.message, "There was an error")
        assert_equal(last_event.timestamp, "2022-02-22 16:54:18 UTC")
      end
    end
  end

  test "#handle only keep a maximum of 10 events" do
    handler = handlers(:email_deliver)
    payload = { id: "1234", email: "test@example.com" }

    Handlers::Emailer.any_instance.stubs(:call)

    10.times do
      handler.handle(payload)
    end

    assert_difference(-> { handler.reload.events.length }, 0) do
      travel_to("2022-02-22 16:54:18 UTC") do
        handler.handle(payload)

        last_event = handler.events.last
        assert_equal(last_event.status, "success")
        assert_equal(last_event.message, "Successful")
        assert_equal(last_event.timestamp, "2022-02-22 16:54:18 UTC")
      end
    end
  end
end
