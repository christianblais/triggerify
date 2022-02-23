class RuleTemplate
  attr_accessor :description, :rule, :handle

  delegate :name, to: :rule

  class << self
    def all
      [
        tagger_on_account_creation,
        sendgrid_on_shipping_order,
        sms_on_low_inventory,
      ]
    end

    def find_by_handle(handle)
      all.detect { |template| template.handle == handle }
    end

    private

    def tagger_on_account_creation
      rule = Rule.new
      rule.name = "New customer require approval"
      rule.topic = "customers/create"
      rule.enabled = true

      handler = Handler.new
      handler.service_name = Handlers::Tagger.to_s
      handler.settings = {
        taggable_type: "Customer",
        taggable_id: "{{ customer_id }}",
        tag_name: "require_approval",
      }

      rule.filters = []
      rule.handlers = [handler]

      template = new
      template.handle = :tagger_on_account_creation
      template.description = "When a customer is created, assign them a tag."
      template.rule = rule
      template
    end

    def sendgrid_on_shipping_order
      rule = Rule.new
      rule.name = "Order received with shippable goods"
      rule.topic = "orders/create"
      rule.enabled = true

      filter = Filter.new
      filter.value = "line_items[*].requires_shipping"
      filter.verb = "equals"
      filter.regex = "true"

      handler = Handler.new
      handler.service_name = Handlers::SendGrid.to_s
      handler.settings = {
        api_key: "REPLACE_ME",
        recipients: "test@example.com, another@test.com",
        from: "store@example.com",
        subject: "New order with shippable goods",
        body: "Order {{ order_number }} from {{ customer.first_name }} requires shipping",
      }

      rule.filters = [filter]
      rule.handlers = [handler]

      template = new
      template.handle = :sendgrid_on_shipping_order
      template.description = "When an order is created and require shipping, send a email."
      template.rule = rule
      template
    end

    def sms_on_low_inventory
      rule = Rule.new
      rule.name = "Item inventory is low"
      rule.topic = "inventory_levels/update"
      rule.enabled = true

      filter = Filter.new
      filter.value = "available"
      filter.verb = "<"
      filter.regex = "5"

      handler = Handler.new
      handler.service_name = Handlers::SMS.to_s
      handler.settings = {
        twilio_account_sid: "REPLACE_ME",
        twilio_auth_token: "REPLACE_ME",
        twilio_from_phone_number: "(555) 555-5555",
        phone_number: "(555) 555-5555",
        message: "Item inventory id \#{{ inventory_item_id }} has dropped to {{ available }}.",
      }

      rule.filters = [filter]
      rule.handlers = [handler]

      template = new
      template.handle = :sms_on_low_inventory
      template.description = "When an item inventory available quantity drops below 5, send a SMS message."
      template.rule = rule
      template
    end
  end
end
