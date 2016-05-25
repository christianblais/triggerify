require 'test_helper'

class ParserTest < ActiveSupport::TestCase
  setup do
    payload = {
      'id' => 1,
      'customer' => {
        'address1' => '555 greendale',
        'properties' => {
          'a' => 123
        }
      }
    }
    @parser = Parser.new(payload)
  end

  test '#parse can access data element' do
    assert_equal 'hello 1!', @parser.parse('hello {{ id }}!')
    assert_equal 'hello 123!', @parser.parse('hello {{ customer.properties.a }}!')
  end

  test '#parse return nil on missing data' do
    assert_equal 'hello !', @parser.parse('hello {{ test }}!')
    assert_equal 'hello !', @parser.parse('hello {{ test.hola }}!')
  end

  test '#parse handle multiple replacements' do
    assert_equal 'hello 1 at address 555 greendale!', @parser.parse('hello {{ id }} at address {{ customer.address1 }}!')
  end
end