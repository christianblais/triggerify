class RuleEvent
  def self.load(attributes)
    object = allocate
    object.instance_variable_set(:@identifier, attributes.fetch("identifier", ""))
    object.instance_variable_set(:@details, attributes.fetch("details").map { RuleEventDetail.load(_1) })
    object
  end

  def initialize(identifier:)
    @identifier = identifier
    @details = []
  end

  attr_reader :details, :identifier

  def add_detail(level, message)
    @details << RuleEventDetail.new(
      level: level,
      message: message,
    )
  end

  def dump
    {
      "identifier" => @identifier,
      "details" => @details.map(&:dump),
    }
  end

  def as_json
    dump.merge({
      name: @identifier,
      error: @details.any? { _1.level == :error },
    })
  end
end
