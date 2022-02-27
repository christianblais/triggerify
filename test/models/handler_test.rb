require 'test_helper'

class HandlerTest < ActiveSupport::TestCase
  setup do
    @handler = handlers(:email_deliver)
  end

  test "#handle increment handle_count" do
    Handlers::Emailer.any_instance.expects(:call)

    assert_difference(-> { @handler.reload.handle_count }, 1) do
      @handler.handle({})
    end
  end

  test "#handle increment handle_count on exceptions" do
    Handlers::Emailer.any_instance.expects(:call).raises(StandardError)

    assert_difference(-> { @handler.reload.handle_count }, 1) do
      assert_raises(StandardError) do
        @handler.handle({})
      end
    end
  end
end
