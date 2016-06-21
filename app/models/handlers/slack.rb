module Handlers
  class Slack < Base
    setting :slack_token,
      name: 'Slack api permission token',
      example: '2e1bad1377ff7faaae75a46f51663531'

    setting :channel,
      name: 'Slack channel',
      example: '#orders'

    setting :message,
      name: 'Message',
      example: '{{ first_name }} {{ last_name }} just placed an order of {{ total_price }}! :tada:'

    def call
      token = slack_token.presence || ENV['SLACK_TOKEN']

      return if [
        channel,
        message,
        token
      ].any?(&:blank?)

      client = ::Slack::Web::Client.new(token: token)
      client.chat_postMessage(channel: channel, text: message)
    end
  end
end
