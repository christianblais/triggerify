module Handlers
  class Tagger < Base
    setting :taggable_type
    setting :taggable_id
    setting :tag_name

    def call
      resource_class = "ShopifyAPI::#{taggable_type}".classify.constantize
      resource = resource_class.find(taggable_id)
      tags = resource.tags.split(',')
      Rails.logger.info("HANDLER: #{tag_name} : #{tags}")
      return if tags.include?(tag_name)
      Rails.logger.info("HANDLER: Continuing!!")
      tags.push(tag_name)
      resource.tags = tags.join(',')
      resource.save
    end
  end
end
