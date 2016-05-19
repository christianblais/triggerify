class CallbackController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def webhook
    Rule.where(topic: params[:topic]).each do |rule|
      handle_rule(rule, params[:callback])
    end
  end

  private

  def handle_rule(rule, callback_params)
    rule.handlers.each do |handler|
      handler.handle(callback_params)
    end
  end
end
