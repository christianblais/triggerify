class RuleEventsSerializer
  class << self
    def dump(array)
      data = array.map { |object| object.dump }
      data.to_json
    end

    def load(string)
      return [] if string.nil?

      array = JSON.parse(string)
      array.map do |data|
        RuleEvent.load(data)
      end
    end
  end
end
