require 'test_helper'

module Handlers
  class TaggerTest < ActiveSupport::TestCase
    test '#call' do
      handler = build_handler

      mock_api = mock
      mock_api.expects(:tags).returns("canada,marketing")
      mock_api.expects(:tags=).with("canada,marketing,VIP")
      mock_api.expects(:save)

      ShopifyAPI::Customer.expects(:find).with("1234").returns(mock_api)

      handler.call
    end

    test '#call tag already exist' do
      handler = build_handler(tag_name: "canada")

      mock_api = mock
      mock_api.expects(:tags).returns("canada,marketing")
      mock_api.expects(:tags=).never
      mock_api.expects(:save).never

      ShopifyAPI::Customer.expects(:find).with("1234").returns(mock_api)

      handler.call
    end

    test '#call resource not found' do
      handler = build_handler

      ShopifyAPI::Customer
        .expects(:find)
        .with("1234")
        .raises(ActiveResource::ResourceNotFound, "Resource not found")

      e = assert_raises(UserError) do
        handler.call
      end
      assert_equal(e.message, "Resource not found: Unable to find Customer with id '1234'")
    end

    test '#call bad request' do
      handler = build_handler(taggable_id: "not-an-id")

      response = stub(
        code: 400,
        message: "Response message = Bad Request (id; expected String to be a id)"
      )
      ShopifyAPI::Customer
        .expects(:find)
        .with("not-an-id")
        .raises(ActiveResource::BadRequest, response)

      e = assert_raises(UserError) do
        handler.call
      end
      assert_equal(e.message, "Bad request: Failed.  Response code = 400.  Response message = Response message = Bad Request (id; expected String to be a id).")
    end

    private

    def build_handler(taggable_type: "Customer", taggable_id: "1234", tag_name: "VIP")
      settings = {
        taggable_type: taggable_type,
        taggable_id: taggable_id,
        tag_name: tag_name,
      }

      Tagger.new(settings, {})
    end
  end
end
