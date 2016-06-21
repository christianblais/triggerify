module Handlers
  class Tagger < Base
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
