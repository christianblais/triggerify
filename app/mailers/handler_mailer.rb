class HandlerMailer < ApplicationMailer
  def email(to:, from:, subject:, body:)
    @body = body
    mail(to: to, from: from, subject: subject)
  end
end
