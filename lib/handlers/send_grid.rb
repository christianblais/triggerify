module Handlers
  class SendGrid < Base
    class DeliveryError < StandardError; end

    label 'Send an email (via SendGrid)'

    description %(
      Use the SendGrid API to send an email.
      <a href="https://github.com/christianblais/triggerify/wiki/Rule-Action-Email-SendGrid" target="_blank">More information</a>
    )

    setting :api_key,
      name: 'SendGrid API Key',
      example: 'SG.HdfSr2Gxxxxxxxxxx_xxxx.uo-38J2ZDhzkjxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

    setting :recipients,
      name: 'List of recipient email addresses',
      example: 'test@example.com, another@test.com'

    setting :from,
      name: 'Email address this email is sent from',
      example: 'store@example.com'

    setting :subject,
      name: 'Title of the email',
      example: 'Hello {{ first_name }}!'

    setting :body,
      name: 'Content of the email',
      example: 'This is an email from triggerify!'

    def call
      mail = ::SendGrid::Mail.new
      mail.from = build_email(email: from)

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

      sg = ::SendGrid::API.new(api_key: api_key)
      response = sg.client.mail._('send').post(request_body: mail.to_json)

      Rails.logger.info "Status: #{response.status_code}"
      Rails.logger.info "Body: #{response.body}"
      Rails.logger.info "Headers: #{response.headers}"

      if response.status_code.to_i != 202
        if known_error?(response)
          raise(UserError, "Unable to send mail. SendGrid replied with the following message: #{response.status_code}. #{response.body}")
        else
          raise(DeliveryError, "Error code: #{response.status_code}. #{response.body}")
        end
      end
    end

    def known_error?(response)
      # {"errors":[{"message":"Authenticated user is not authorized to send mail","field":null,"help":null}]}
      return true if response.status_code.to_i == 401
      # {"errors":[{"message":"The from address does not match a verified Sender Identity. Mail cannot be sent until this error is resolved. Visit https://sendgrid.com/docs/for-developers/sending-email/sender-identity/ to see the Sender Identity requirements","field":"from","help":null}]}
      return true if response.status_code.to_i == 403

      false
    end

    def build_email(email:)
      ::SendGrid::Email.new(email: email)
    rescue ArgumentError => e
      raise UserError, "Unable to send mail. SendGrid replied with the following message: #{e.message}"
    end
  end
end
