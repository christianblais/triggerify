module Handlers
  class Slack < Base
    setting :slack_token
    setting :channel
    setting :message

    def call
      return if channel.blank? || message.blank?

      client = ::Slack::Web::Client.new(token: slack_token.presence || ENV['SLACK_TOKEN'])
      client.chat_postMessage(channel: channel, text: message)
    end
  end
end
