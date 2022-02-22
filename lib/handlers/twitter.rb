module Handlers
  class Twitter < Base
    label 'Send a tweet'

    description %(
      Use the Twitter API to send a tweet.
      <a href="https://github.com/christianblais/triggerify/wiki/Rule-Action-Twitter" target="_blank">More information</a>
    )

    setting :consumer_key,
      name: 'Twitter consumer key'

    setting :consumer_secret,
      name: 'Twitter consumer secret'

    setting :access_token,
      name: 'Twitter access token'

    setting :access_token_secret,
      name: 'Twitter secret token'

    setting :message,
      name: 'Message',
      example: 'New order from {{ first_name }}!'

    def call
      raise(UserError, "Missing 'consumer_key'") if consumer_key.blank?
      raise(UserError, "Missing 'consumer_secret'") if consumer_secret.blank?
      raise(UserError, "Missing 'access_token'") if access_token.blank?
      raise(UserError, "Missing 'access_token_secret'") if access_token_secret.blank?

      client = ::Twitter::REST::Client.new do |config|
        config.consumer_key = consumer_key
        config.consumer_secret = consumer_secret
        config.access_token = access_token
        config.access_token_secret = access_token_secret
      end

      client.update(message)
    end
  end
end
