class RuleEvent
  def self.load(attributes)
    object = allocate
    object.instance_variable_set(:@timestamp, DateTime.parse(attributes.fetch("timestamp")))
    object.instance_variable_set(:@details, attributes.fetch("details").map { RuleEventDetail.load(_1) })
    object
  end

  def initialize
    @timestamp = DateTime.now.utc
    @details = []
  end

  attr_reader :timestamp, :details

  def add_detail(level, message)
    @details << RuleEventDetail.new(
      level: level,
      message: message,
    )
  end

  def dump
    {
      "timestamp" => timestamp.to_s(:db),
      "details" => details.map(&:dump),
    }
  end
end
