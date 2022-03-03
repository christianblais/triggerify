class RuleEvent
  def self.load(attributes)
    object = allocate
    object.instance_variable_set(:@details, attributes.fetch("details").map { RuleEventDetail.load(_1) })
    object
  end

  def initialize
    @details = []
  end

  attr_reader :details

  def add_detail(level, message)
    @details << RuleEventDetail.new(
      level: level,
      message: message,
    )
  end

  def dump
    {
      "details" => @details.map(&:dump),
    }
  end
end
