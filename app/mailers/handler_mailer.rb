class HandlerMailer < ApplicationMailer
  def email(to:, subject:, body:)
    @body = body
    mail(to: to, subject: subject)
  end
end
