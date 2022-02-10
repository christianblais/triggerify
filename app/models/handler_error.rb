class HandlerError
  attr_reader :message, :timestamp

  def initialize(message:, timestamp:)
    @message = message
    @timestamp = timestamp
  end
end