class CallbackController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def webhook
    Rails.logger.info(params)
  end
end
