require 'test_helper'

class FilterValidatorTest < ActiveSupport::TestCase
  test '#valid? handle nested values' do
    filter = Filter.new(
      regex: '0',
      verb: 'equals',
      value: "{{ info.more.detailed }}"
    )

    parser = FilterValidator.new(filter)

    assert_equal true, parser.valid?({
      'info' => {
        'more' => {
          'detailed' => '0'
        }
      }
    })

    assert_equal false, parser.valid?({
      'info' => {
        'more' => {
          'detailed' => '1'
        }
      }
    })

    assert_equal false, parser.valid?({
      'info' => 'lol'
    })

    assert_equal false, parser.valid?({
      'info' => {
        'more' => {
          'detailed' => nil
        }
      }
    })

    assert_equal false, parser.valid?({
      'info' => {
        'more' => {
          'uhoh' => nil
        }
      }
    })
  end

  test '#valid? handle parsed values' do
    filter = Filter.new(
      regex: '{{ info.more.equivalent }}',
      verb: 'equals',
      value: "{{ info.more.detailed }}"
    )

    parser = FilterValidator.new(filter)

    assert_equal true, parser.valid?({
      'info' => {
        'more' => {
          'detailed' => '0',
          'equivalent' => '0'
        }
      }
    })

    assert_equal false, parser.valid?({
      'info' => {
        'more' => {
          'detailed' => '0',
          'equivalent' => '1'
        }
      }
    })
  end

  test '#valid? handle `all` arrays' do
    filter = Filter.new(
      regex: '0',
      verb: 'equals',
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
      verb: 'equals',
      value: "{{ info[*] }}"
    )

    parser = FilterValidator.new(filter)

    assert_equal true, parser.valid?({
      'info' => [
        0,
        1
      ]
    })

    assert_equal false, parser.valid?({
      'info' => [
        1,
        1
      ]
    })
  end

  test '#valid? handle `nth` arrays' do
    filter = Filter.new(
      regex: '{{ info[n].x }}',
      verb: '>',
      value: "{{ info[*].y }}"
    )

    parser = FilterValidator.new(filter)

    assert_equal false, parser.valid?({
      'info' => [
        {
          'x' => 0,
          'y' => 0,
        },
        {
          'x' => 1,
          'y' => 1,
        }
      ]
    })

    assert_equal true, parser.valid?({
      'info' => [
        {
          'x' => 0,
          'y' => 1,
        },
        {
          'x' => 1,
          'y' => 1,
        }
      ]
    })

    assert_equal true, parser.valid?({
      'info' => [
        {
          'x' => 1,
          'y' => 1,
        },
        {
          'x' => 0,
          'y' => 1,
        }
      ]
    })

    assert_equal true, parser.valid?({
      'info' => [
        {
          'x' => 0,
          'y' => 1,
        },
        {
          'x' => 0,
          'y' => 1,
        }
      ]
    })

    assert_equal false, parser.valid?({
      'info' => [
        {
          'x' => 1,
          'y' => 0,
        },
        {
          'x' => 1,
          'y' => 0,
        }
      ]
    })

    assert_equal false, parser.valid?({
      'info' => [
        {
          'x' => 1,
          'y' => 0,
        },
        {
          'x' => 1,
          'y' => 1,
        }
      ]
    })
  end

  test '#valid? handle invalid access (Array)' do
    filter = Filter.new(
      regex: '0',
      verb: 'equals',
      value: "{{ info.test }}"
    )

    parser = FilterValidator.new(filter)

    assert_equal false, parser.valid?({
      'info' => [
        { 'a' => 1 }
      ]
    })
  end

  test '#valid? handle invalid access (Hash)' do
    filter = Filter.new(
      regex: '0',
      verb: 'equals',
      value: "{{ info[0] }}"
    )

    parser = FilterValidator.new(filter)

    assert_equal false, parser.valid?({
      'info' => {
        'a' => 1
      }
    })
  end
end
