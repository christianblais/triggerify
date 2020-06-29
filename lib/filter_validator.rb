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

  def valid_element?(result, elements, iterations = [])
    method, *elements = elements

    if method.nil?
      parsed = @parser.parse(@filter.regex, *iterations)
      return @filter.valid_for?(parsed, result.to_s)
    end

    if method.match(ALL)
      return false unless result.is_a?(Array)

      result.each.with_index.all? do |x, index|
        valid_element?(x, elements, iterations + [index])
      end
    elsif method.match(ONE)
      return false unless result.is_a?(Array)

      result.each.with_index.any? do |x, index|
        valid_element?(x, elements, iterations + [index])
      end
    else
      return false unless result.is_a?(Hash)

      method, *ints = method.split(INT)
      result = result.try(:[], method)

      ints.each do |int|
        result = result.try(:[], int.to_i)
      end

      valid_element?(result, elements, iterations)
    end
  end
end
