module Handlers
  class SMS < Base
    description %(
      Use the Twillio API to send a SMS.
      <a href="https://www.twilio.com/docs/api/ip-messaging/guides/identity" target="_blank">Click here</a>
      for more information.
    )

    setting :twilio_account_sid,
      name: 'Twilio account sid',
      example: 'AC1234567890abcdef1234567890abcdef'

    setting :twilio_auth_token,
      name: 'Twilio auth token',
      example: '1234567890abcdef1234567890abcdef'

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
      return if [
        phone_number,
        message,
        twilio_account_sid,
        twilio_auth_token,
        twilio_from_phone_number
      ].any?(&:blank?)

      client = Twilio::REST::Client.new(twilio_account_sid, twilio_auth_token)
      client.messages.create(
        from: twilio_from_phone_number,
        to: phone_number,
        body: message,
      )
    end
  end
end
