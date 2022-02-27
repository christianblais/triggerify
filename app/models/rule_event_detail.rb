class RuleEventDetail
  def self.load(attributes)
    object = allocate
    object.instance_variable_set(:@level, attributes.fetch('level').to_sym)
    object.instance_variable_set(:@message, attributes.fetch("message"))
    object
  end

  def initialize(level:, message:)
    @level = level
    @message = message
  end

  attr_reader :level, :message

  def dump
    {
      "level" => level.to_s,
      "message" => message,
    }
  end
end
