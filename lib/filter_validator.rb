class FilterValidator
  ALL = /(\[\+\])/
  ONE = /(\[\*\])/
  INT = /\[(\d)\]/
  DOT = /\./

  def initialize(filter)
    @filter = filter
  end

  def valid?(payload)
    @parser = Parser.new(payload)

    regex = Regexp.union(ALL, ONE, DOT)
    value = @filter.value.gsub(/\{|\}/, '').strip
    array = value.split(regex).reject(&:blank?)

    valid_element?(payload, array)
  end

  private

  def valid_element?(result, elements, iteration = nil)
    method, *elements = elements

    if method.nil?
      return @filter.valid_for?(@parser, result.to_s, iteration)
    end

    if method.match(ALL)
      Array.wrap(result).each.with_index.all? do |x, index|
        valid_element?(x, elements, index)
      end
    elsif method.match(ONE)
      Array.wrap(result).each.with_index.any? do |x, index|
        valid_element?(x, elements, index)
      end
    else
      method, *ints = method.split(INT)
      result = result.try(:[], method)

      ints.each do |int|
        result = result.try(:[], int.to_i)
      end

      valid_element?(result, elements, iteration)
    end
  end
end
