class Parser
  REGEX = /\{\{\s*(\S+)\s*\}\}/

  def initialize(payload)
    @payload = payload
  end

  # parse liquidish thingies
  def parse(content, *n)
    content.gsub(REGEX) do |str|
      elements = str.match(REGEX)[1].split('.')

      result = @payload
      elements.each do |element|
        method, *arrays = element.split('[')

        result = if result.is_a?(Hash)
          result.try(:[], method)
        else
          nil
        end

        arrays.each do |i|
          result =
            if i.match(/n/)
              result.try(:[], n.shift.to_i)
            else
              result.try(:[], i.to_i)
            end
        end
      end
      result.to_s
    end
  end
end
