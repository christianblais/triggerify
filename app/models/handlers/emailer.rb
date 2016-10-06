module Handlers
  class Emailer < Base
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
      ActionMailer::Base.smtp_settings = {
        :port           => ENV['MAILGUN_SMTP_PORT'],
        :address        => ENV['MAILGUN_SMTP_SERVER'],
        :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
        :password       => ENV['MAILGUN_SMTP_PASSWORD'],
        :domain         => ENV['MAILGUN_DOMAIN'],
        :authentication => :plain,
      }

      HandlerMailer.email(to: recipients, from: 'no-reply@email.com', subject: subject, body: body).deliver_later
    end
  end
end
