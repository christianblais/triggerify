module Handlers
  class Tagger < Base
    label 'Add a tag to a Shopify resource'

    description %(
      Add a tag to Shopify resource on your store.
      <a href="https://github.com/christianblais/triggerify/wiki/Rule-Action-Shopify-Tag" target="_blank">More information</a>
    )

    setting :taggable_type,
      options: %w(Order Customer),
      name: 'Resource type',
      example: 'Customer'

    setting :taggable_id,
      name: 'Resource ID',
      example: '{{ customer_id }}'

    setting :tag_name,
      name: 'Tag name',
      example: 'triggerified'

    def call
      resource_class = "ShopifyAPI::#{taggable_type}".classify.constantize
      resource = resource_class.find(taggable_id)
      tags = resource.tags.split(',').map(&:strip)
      return if tags.include?(tag_name.strip)
      tags.push(tag_name)
      resource.tags = tags.join(',')
      resource.save
    end
  end
end
