class RuleEventDetail
  def self.load(attributes)
    object = allocate
    object.instance_variable_set(:@timestamp, DateTime.parse(attributes.fetch("timestamp")))
    object.instance_variable_set(:@level, attributes.fetch('level').to_sym)
    object.instance_variable_set(:@message, attributes.fetch("message"))
    object
  end

  def initialize(level:, message:)
    @timestamp = DateTime.now.utc
    @level = level
    @message = message
  end

  attr_reader :timestamp, :level, :message

  def dump
    {
      "timestamp" => @timestamp.to_s(:db),
      "level" => @level.to_s,
      "message" => @message,
    }
  end
end
