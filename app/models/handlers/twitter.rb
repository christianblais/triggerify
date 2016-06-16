module Handlers
  class Twitter < Base
    setting :consumer_key,
      info: 'Twitter consumer key',
      example: '286b88262a15cf9aad3a6961e34deaba'

    setting :consumer_secret,
      info: 'Twitter consumer secret',
      example: '6ae6b6920e58c15edb260a766dc58420'

    setting :access_token,
      info: 'Twitter access token',
      example: '45c78fd5876ffcad580b65daae3d041a'

    setting :access_token_secret,
      info: 'Twitter secret token',
      example: ''

    setting :message,
      info: '90a6a4d94ed9545af207a972109e84e5',
      example: 'Message of the Tweet'

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
