class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@email.com"
  layout 'mailer'
end
