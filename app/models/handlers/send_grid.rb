module Handlers
  class SendGrid < Base
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
      example: 'my.name@something.com'

    setting :subject,
      name: 'Title of the email',
      example: 'Hello {{ first_name }}!'

    setting :body,
      name: 'Content of the email',
      example: 'This is an email from triggerify!'

    def call
      HandlerMailer.smtp_settings = {
        :port           => 587,
        :address        => 'smtp.sendgrid.net',
        :domain         => 'triggerify.herokuapp.com',
        :user_name      => 'apikey',
        :password       => api_key,
        :authentication => :plain,
      }

      HandlerMailer.email(to: recipients, from: from, subject: subject, body: body).deliver_later
    end
  end
end
