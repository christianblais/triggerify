module Handlers
  class SMS < Base
    setting :twilio_account_sid,
      name: 'Twilio account id',
      example: '{{ 230122901525848 }}'

    setting :twilio_auth_token,
      name: 'Twilio api permission token',
      example: '0cf24305167f2396aa3f5c16f2e827c4'

    setting :twilio_from_phone_number,
      name: 'The Twilio phone number attached to your account you wish to use',
      example: '(555) 555-5555'

    setting :phone_number,
      name: 'The message receiver phone number',
      example: '(555) 555-5555'

    setting :message,
      name: 'Message',
      example: 'An order just came in from {{ first_name }} {{ last_name }}!'

    def call
      computed_twilio_account_sid = twilio_account_sid.presence || ENV['TWILIO_ACCOUNT_SID']
      computed_twilio_auth_token = twilio_auth_token.presence || ENV['TWILIO_AUTH_TOKEN']
      computed_twilio_from_phone_number = twilio_from_phone_number.presence || ENV['TWILIO_NUMBER']

      return if [
        phone_number,
        message,
        computed_twilio_account_sid,
        computed_twilio_auth_token,
        computed_twilio_from_phone_number
      ].any?(&:blank?)

      client = Twilio::REST::Client.new(computed_twilio_account_sid, computed_twilio_auth_token)
      client.account.messages.create(from: computed_twilio_from_phone_number, to: phone_number, body: message)
    rescue Twilio::REST::RequestError => e
      Rails.logger.debug(e)
    end
  end
end
