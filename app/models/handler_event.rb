class HandlerEvent
  include ActiveModel::Serialization

  STATUS_SUCCESS = "success"
  STATUS_ERROR = "error"

  def initialize(status:, message:, timestamp:)
    @status = status
    @message = message
    @timestamp = timestamp
  end

  attr_accessor :status, :message, :timestamp
end
