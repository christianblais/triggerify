require 'net/http'

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
      resource = find_taggable(taggable_type, taggable_id)
      tags = resource.tags.split(',').map(&:strip)

      if tags.include?(tag_name.strip)
        Rails.logger.info("Tagger tag already present: skip")
        return
      end

      tags.push(tag_name)

      host = @shop.shopify_domain
      path = "/admin/api/2022-07/#{taggable_type.downcase}s/#{taggable_id}.json"

      headers = {
        "Content-Type" => "application/json",
        "X-Shopify-Access-Token" => @shop.shopify_token,
      }

      payload = {
        taggable_type.downcase => {
          "tags" => tags.join(',')
        }
      }

      req = Net::HTTP::Put.new(path, headers)

      # Deliberately not using ActiveResource to avoid an issue on Shopify end
      # ActiveResource uploads all params of the resource, not only the mutated elements
      req.body = payload.to_json
      http = Net::HTTP.new(host, 443)
      http.use_ssl = true
      http.start { |h| h.request(req) }
    end

    private

    def find_taggable(taggable_type, taggable_id)
      resource_class = "ShopifyAPI::#{taggable_type}".classify.constantize
      resource_class.find(taggable_id)
    rescue ActiveResource::BadRequest => e
      raise(UserError, "Unable to tag resource. Shopify replied with the following message: #{e.message}")
    rescue ActiveResource::ResourceNotFound
      raise(UserError, "Unable to tag resource as Shopify can't find #{taggable_type} with id '#{taggable_id}'")
    end
  end
end
