require 'test_helper'

class FilterValidatorTest < ActiveSupport::TestCase
  test '#valid? handle `all` arrays' do
    filter = Filter.new(
      regex: '0',
      verb: 'equal',
      value: "{{ info[+] }}"
    )

    parser = FilterValidator.new(filter)

    assert_equal true, parser.valid?({
      'info' => [
        0,
        0
      ]
    })

    assert_equal false, parser.valid?({
      'info' => [
        0,
        1
      ]
    })
  end

  test '#valid? handle `one` arrays' do
    filter = Filter.new(
      regex: '0',
      verb: 'equal',
      value: "{{ info[*] }}"
    )

    parser = FilterValidator.new(filter)

    assert_equal true, parser.valid?(payload = {
      'info' => [
        0,
        1
      ]
    })

    assert_equal false, parser.valid?(payload = {
      'info' => [
        1,
        1
      ]
    })
  end
end
