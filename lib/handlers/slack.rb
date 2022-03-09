module Handlers
  class Slack < Base
    label 'Send a message on Slack'

    description %(
      Use the Slack API to send a message.
      <a href="https://get.slack.help/hc/en-us/articles/215770388-Create-and-regenerate-API-tokens" target="_blank">Click here</a>
      for more information.
    )

    deprecated!

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
      raise(UserError, "Missing 'slack_token'") if slack_token.blank?
      raise(UserError, "Missing 'message'") if message.blank?
      raise(UserError, "Missing 'channel'") if channel.blank?

      client = ::Slack::Web::Client.new(token: slack_token)

      begin
        client.chat_postMessage(channel: channel, text: message)
      rescue ::Slack::Web::Api::Errors::ServerError, ::Slack::Web::Api::Errors::SlackError, ::Slack::Web::Api::Errors::TooManyRequestsError => e
        raise(UserError, "Unable to send Slack message. Slack replied with the following message: #{e.message}")
      end
    end
  end
end
