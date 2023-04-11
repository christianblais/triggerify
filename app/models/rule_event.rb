class RuleEvent
  def self.load(attributes)
    object = allocate

    # Ensures we do not bust on historic events that do not have an identifier
    object.instance_variable_set(:@shopify_identifier, attributes.fetch("shopify_identifier", attributes.fetch("identifier", "")))
    object.instance_variable_set(:@hooklys_identifier, attributes.fetch("hooklys_identifier", ""))

    object.instance_variable_set(:@details, attributes.fetch("details").map { RuleEventDetail.load(_1) })
    object
  end

  def initialize(shopify_identifier:, hooklys_identifier:)
    @shopify_identifier = shopify_identifier
    @hooklys_identifier = hooklys_identifier
    @details = []
  end

  attr_reader :details, :shopify_identifier, :hooklys_identifier

  def add_detail(level, message)
    @details << RuleEventDetail.new(
      level: level,
      message: message,
    )
  end

  def dump
    {
      "shopify_identifier" => @shopify_identifier,
      "hooklys_identifier" => @hooklys_identifier,
      "details" => @details.map(&:dump),
    }
  end

  def as_json
    dump.merge({
      shopify_identifier: @shopify_identifier,
      hooklys_identifier: @hooklys_identifier,
      timestamp: @details.first.timestamp.to_fs(:db),
      error: @details.any? { _1.level == :error },
    })
  end
end
