class SyncWebhookJob < ShopJob
  def perform_with_shop(*_args)
    create_missing_webhooks
    delete_extra_webhooks
  end

  private

  def create_missing_webhooks
    desired_topics.each do |topic|
      next if existing_topics.include?(topic)

      ShopifyAPI::Webhook.create(
        address: "#{callback_path}/#{topic}",
        format: 'json',
        topic: topic,
      )
    end
  end

  def delete_extra_webhooks
    existing_webhooks.each do |webhook|
      next if desired_topics.include?(webhook.topic)

      webhook.destroy
    end
  end

  def callback_path
    "#{Rails.configuration.application_url}/webhooks/rules/#{shop.id}"
  end

  def desired_topics
    shop.rules.all.distinct(:topic).pluck(:topic)
  end

  def existing_topics
    existing_webhooks.map(&:topic)
  end

  def existing_webhooks
    @existing_webhooks ||= ShopifyAPI::Webhook.all
  end
end
