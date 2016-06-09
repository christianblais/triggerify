module Handlers
  class SMS < Base
    setting :twilio_account_sid
    setting :twilio_auth_token
    setting :twilio_from_phone_number
    setting :phone_number
    setting :message

    def call
      return if phone_number.blank? || message.blank?

      sid = twilio_account_sid.presence || ENV['TWILIO_ACCOUNT_SID']
      key = twilio_auth_token.presence || ENV['TWILIO_AUTH_TOKEN']
      nbr = twilio_from_phone_number.presence || ENV['TWILIO_NUMBER']

      client = Twilio::REST::Client.new(sid, key)
      client.account.messages.create(from: nbr, to: phone_number, body: message)
    rescue Twilio::REST::RequestError => e
      Rails.logger.debug(e)
    end
  end
end
