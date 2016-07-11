class Parser
  REGEX = /\{\{\s*(\S+)\s*\}\}/

  def initialize(payload)
    @payload = payload
  end

  # parse liquidish thingies
  def parse(content)
    content.gsub(REGEX) do |str|
      elements = str.match(REGEX)[1].split('.')

      result = @payload
      elements.each do |element|
        method, *arrays = element.split('[')
        result = result.try(:[], method)
        arrays.each do |i|
          result = result.try(:[], i.to_i)
        end
      end
      result.to_s
    end
  end
end
