module Handlers
  class Emailer < Base
    class DeliveryError < StandardError; end

    label 'Send an email (Test only)'

    description %(
      Note that this is for test purposes only. No guaranteed delivery whatsoever.
      For real email deliveries, please use SendGrid with your own API key.
      <a href="https://github.com/christianblais/triggerify/wiki/Rule-Action-Email-Test" target="_blank">More information</a>
    )

    setting :recipients,
      name: 'List of recipient email addresses',
      example: 'test@example.com, another@test.com'

    setting :subject,
      name: 'Title of the email',
      example: 'Hello {{ first_name }}!'

    setting :body,
      name: 'Content of the email',
      example: 'This is an email from Triggerify!'

    def call
      mail = ::SendGrid::Mail.new
      mail.from = ::SendGrid::Email.new(email: ENV.fetch('HANDLER_EMAILER_FROM'))

      personalization = ::SendGrid::Personalization.new
      recipients.split(",").each do |recipient|
        recipient_sanitized = recipient.strip
        next if recipient_sanitized.empty?

        email = build_email(email: recipient_sanitized)
        personalization.add_to(email)
      end
      mail.add_personalization(personalization)

      mail.subject = subject
      mail.add_content(::SendGrid::Content.new(type: 'text/plain', value: body))

      sg = ::SendGrid::API.new(api_key: ENV.fetch('HANDLER_EMAILER_API_KEY'))
      response = sg.client.mail._('send').post(request_body: mail.to_json)

      Rails.logger.info "Status: #{response.status_code}"
      Rails.logger.info "Body: #{response.body}"
      Rails.logger.info "Headers: #{response.headers}"

      if response.status_code.to_i != 202
        raise DeliveryError, "Error code: #{response.status_code}. #{response.body}"
      end
    end

    def build_email(email:)
      ::SendGrid::Email.new(email: email)
    rescue ArgumentError => e
      raise UserError, "Unable to send mail. SendGrid replied with the following message: #{e.message}"
    end
  end
end
