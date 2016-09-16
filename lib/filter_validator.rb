class FilterValidator
  ALL = /(\[\+\])/
  ONE = /(\[\*\])/
  INT = /\[(\d)\]/
  DOT = /\./

  def initialize(filter)
    @filter = filter
  end

  def valid?(payload)
    regex = Regexp.union(ALL, ONE, DOT)
    value = @filter.value.gsub(/\{|\}/, '').strip
    array = value.split(regex).reject(&:blank?)

    valid_element?(payload, array)
  end

  private

  def valid_element?(result, elements)
    method, *elements = elements

    return @filter.valid_for?(result.to_s) if method.nil?

    if method.match(ALL)
      Array.wrap(result).all? do |x|
        valid_element?(x, elements)
      end
    elsif method.match(ONE)
      Array.wrap(result).any? do |x|
        valid_element?(x, elements)
      end
    else
      method, *ints = method.split(INT)
      result = result.try(:[], method)

      ints.each do |int|
        result = result.try(:[], int.to_i)
      end

      valid_element?(result, elements)
    end
  end
end
