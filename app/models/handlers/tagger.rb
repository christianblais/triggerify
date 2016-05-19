module Handlers
  class Tagger < Base
    SETTINGS = %w(
      taggable_type
      taggable_id
      tag_name
    )

    delegate :taggable_id, :taggable_type, :tag_name, to: :settings

    def handle(payload)
      resource = "ShopifyApi::#{taggable_type}".constantize.find(taggable_id)
      tags = resource.tags.split(',')
      tags.push(tag_name)
      resource.tags = tags.join(',')
      resource.save
    end
  end
end
