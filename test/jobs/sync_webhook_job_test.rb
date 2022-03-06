require 'test_helper'

class SyncWebhookJobTest < ActiveSupport::TestCase
  setup do
    @job = SyncWebhookJob.new
  end

  test "#perform registers app uninstall" do
    ShopifyAPI::Webhook
      .expects(:all)
      .returns([])
      .twice

    ShopifyAPI::Webhook
      .expects(:create!)
      .with(
        address: "https://example.com/webhooks/receive",
        format: 'json',
        topic: "app/uninstalled",
      )

    shop = create_shop

    @job.perform(shop_domain: shop.shopify_domain)
  end

  test "#perform registers webhook for created rules" do
    ShopifyAPI::Webhook
      .expects(:all)
      .returns([existing_webhook("app/uninstalled")])
      .twice

    ShopifyAPI::Webhook
      .expects(:create!)
      .with(
        address: "https://example.com/webhooks/receive",
        format: 'json',
        topic: "customers/create",
      )

    shop = create_shop
    shop.rules.create!(
      name: 'Test',
      topic: 'customers/create',
      enabled: true
    )

    @job.perform(shop_domain: shop.shopify_domain)
  end

  test "#perform destroy unexpected topic existing webhook" do
    unexpected = existing_webhook("something/unexpected")

    ShopifyAPI::Webhook
      .expects(:all)
      .returns([existing_webhook("app/uninstalled"), unexpected])
      .twice

    unexpected.expects(:destroy)

    shop = create_shop

    @job.perform(shop_domain: shop.shopify_domain)
  end

  test "#perform destroy unexpected address existing webhook" do
    unexpected = existing_webhook("app/uninstalled", address: "http://example.com/unexpected")

    ShopifyAPI::Webhook
      .expects(:all)
      .returns([existing_webhook("app/uninstalled"), unexpected])
      .twice

    unexpected.expects(:destroy)

    shop = create_shop

    @job.perform(shop_domain: shop.shopify_domain)
  end

  test "#perform destroy unexpected format existing webhook" do
    unexpected = existing_webhook("app/uninstalled", format: "xml")

    ShopifyAPI::Webhook
      .expects(:all)
      .returns([existing_webhook("app/uninstalled"), unexpected])
      .twice

    unexpected.expects(:destroy)

    shop = create_shop

    @job.perform(shop_domain: shop.shopify_domain)
  end

  private

  def create_shop
    Shop.create!(
      shopify_domain: "example.myshopify.com",
      shopify_token: "1234",
    )
  end

  def existing_webhook(topic, address: "https://example.com/webhooks/receive", format: 'json')
    ShopifyAPI::Webhook.new(
      address: address,
      format: format,
      topic: topic,
    )
  end
end
