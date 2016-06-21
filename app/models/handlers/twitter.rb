module Handlers
  class Twitter < Base
    description %(
      Use the Twitter API to send a tweet.
      <a href="https://apps.twitter.com" target="_blank">Click here</a>
      for more information.
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
      computed_consumer_key = consumer_key.presence || ENV['TWITTER_CONSUMER_KEY']
      computed_consumer_secret = consumer_secret.presence || ENV['TWITTER_CONSUMER_SECRET']
      computed_access_token = access_token.presence || ENV['TWITTER_ACCESS_TOKEN']
      computed_access_token_secret = access_token_secret.presence || ENV['TWITTER_ACCESS_TOKEN_SECRET']

      return if [
        computed_consumer_key,
        computed_consumer_secret,
        computed_access_token,
        computed_access_token_secret
      ].any?(&:blank?)

      client = ::Twitter::REST::Client.new do |config|
        config.consumer_key = computed_consumer_key
        config.consumer_secret = computed_consumer_secret
        config.access_token = computed_access_token
        config.access_token_secret = computed_access_token_secret
      end

      client.update(message)
    end
  end
end
