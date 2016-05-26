module Handlers
  class Emailer < Base
    setting :recipients
    setting :subject
    setting :body

    def call
      HandlerMailer.email(to: recipients, subject: subject, body: body).deliver_later
    end
  end
end
