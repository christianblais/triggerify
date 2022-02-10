require 'test_helper'

class HandlerTest < ActiveSupport::TestCase
  test "persist handler errors" do
    travel_to(Time.now.utc)
    
    handler = rules(:email).handlers.create(service_name: 'Handlers::Base')
    handler.handle('')

    error = handler.last_errors.first

    assert_equal(error.timestamp, Time.now.utc)
    assert_equal(error.message, "Implement this method in a child class")
  end

  test "persist no more than maximum errors" do
    handler = rules(:email).handlers.create(service_name: 'Handlers::Base')

    (Handler::LAST_ERRORS_COUNT + 1).times do
      handler.handle('')
    end

    assert_equal(Handler::LAST_ERRORS_COUNT, handler.last_errors.size)
  end
end
