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
        result = result.try(:[], element)
      end
      result.to_s
    end
  end
end
