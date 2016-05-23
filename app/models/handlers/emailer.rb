module Handlers
  class Emailer < Base
    setting :recipients
    setting :subject
    setting :body
  end
end
