module Handlers
  class Tagger < Base
    setting :taggable_type, options: %w(Order Customer),
      info: 'The resource type to be tagged',
      example: 'Customer'

    setting :taggable_id,
      info: 'The resource id to be tagged',
      example: '{{ customer_id }}'

    setting :tag_name,
      info: 'The tag to be applied',
      example: 'purchase_made_during_promotion'

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
