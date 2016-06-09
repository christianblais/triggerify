module Handlers
  class SMS < Base
    setting :phone_number
    setting :message

    def call
      return if phone_number.blank? || message.blank?

      client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
      client.account.messages.create(
        from: ENV['TWILIO_NUMBER'],
        to: phone_number,
        body: message
      )
    rescue Twilio::REST::RequestError => e
      Rails.logger.debug(e)
    end
  end
end
