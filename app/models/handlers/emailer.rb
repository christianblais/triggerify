module Handlers
  class Emailer < Base
    setting :recipients,
      name: 'List of recipient emails',
      example: 'test@example.com, another@test.com'

    setting :subject,
      name: 'Title of the email',
      example: 'Hello {{ first_name }}!'

    setting :body,
      name: 'Content of the email',
      example: 'This is an email from triggerify!'

    def call
      HandlerMailer.email(to: recipients, subject: subject, body: body).deliver_later
    end
  end
end
