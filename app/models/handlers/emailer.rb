module Handlers
  class Emailer < Base
    SETTINGS = %w(
      recipients
      subject
      body
    )
  end
end
