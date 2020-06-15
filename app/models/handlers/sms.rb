module Handlers
  class SMS < Base
    label 'Send a SMS (via Twillio)'

    description %(
      Use the Twillio API to send a SMS.
      <a href="https://github.com/christianblais/triggerify/wiki/Rule-Action-SMS-Twillio" target="_blank">More information</a>
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

    TWILLIO_ERRORS = [
      20404, # Unable to create record (auth error)
      21211, # Unable to create record The 'To' number 555-555-5555 is not a valid phone number"
      21606, # Unable to create record The 'From' phone number 555-555-5555 is not a valid, SMS-capable inbound phone number or short code for your account.
    ].freeze

    def call
      return if [
        phone_number,
        message,
        twilio_account_sid,
        twilio_auth_token,
        twilio_from_phone_number
      ].any?(&:blank?)

      call_twillio
    end

    private

    def call_twillio
      client = Twilio::REST::Client.new(twilio_account_sid, twilio_auth_token)
      client.messages.create(
        from: twilio_from_phone_number,
        to: phone_number,
        body: message,
      )
    rescue Twilio::REST::RestError => e
      if known_error?(e)
        Rails.logger.info("Twillio silenced error: #{e.message}")
        return
      end

      raise
    end

    def known_error?(e)
      match = e.message.match(/^\[.+?\] (?<code>\d+) :/)
      return false unless match

      TWILLIO_ERRORS.any? { |code| code == match[:code].to_i }
    end
  end
end
