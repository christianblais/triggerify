module Handlers
  class Emailer < Base
    label 'Send an email (Test only)'

    description %(
      Note that this is for test purposes only. No guaranteed delivery whatsoever.
      For real email deliveries, please use SendGrid with your own API key.
      <a href="https://github.com/christianblais/triggerify/wiki/Rule-Action-Email-Test" target="_blank">More information</a>
    )

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
      example: 'This is an email from Triggerify!'

    def call
      ActionMailer::Base.smtp_settings = {
        :port           => ENV['MAILGUN_SMTP_PORT'],
        :address        => ENV['MAILGUN_SMTP_SERVER'],
        :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
        :password       => ENV['MAILGUN_SMTP_PASSWORD'],
        :domain         => ENV['MAILGUN_DOMAIN'],
        :authentication => :plain,
      }

      HandlerMailer.email(to: recipients, from: 'no-reply@email.com', subject: subject, body: body).deliver_now!
    end
  end
end
