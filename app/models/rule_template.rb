class RuleTemplate
  attr_accessor :description, :rule, :handle

  delegate :name, to: :rule

  class << self
    def all
      [
        tagger_on_account_creation,
        sendgrid_on_shipping_order,
        sms_on_low_inventory,
        tag_customer_on_specific_item,
        email_on_tagged_customer,
      ]
    end

    def find_by_handle(handle)
      all.detect { |template| template.handle == handle }
    end

    private

    def email_on_tagged_customer
      rule = Rule.new
      rule.name = "Email me when a WHOLESALE customer buys something"
      rule.topic = "orders/create"
      rule.enabled = true

      filter = Filter.new
      filter.value = "customer.tags"
      filter.verb = "includes"
      filter.regex = "WHOLESALE"

      handler = Handler.new
      handler.service_name = Handlers::SendGrid.to_s
      handler.settings = {
        api_key: "REPLACE_ME",
        recipients: "test@example.com, another@test.com",
        from: "store@example.com",
        subject: "New order for wholesale customer",
        body: "Wholesale order {{ order_number }} from {{ customer.first_name }}",
      }

      rule.filters = [filter]
      rule.handlers = [handler]

      template = new
      template.handle = :email_on_tagged_customer
      template.description = "This rule is perfect if you'd like to get notified whenever a certain type of customers buy something on your store. \
This is achieved by leveraging customers tags, and only notify when a specific tag is present."
      template.rule = rule
      template
    end

    def tag_customer_on_specific_item
      rule = Rule.new
      rule.name = "Tag customers who buy a specific item"
      rule.topic = "orders/create"
      rule.enabled = true

      filter = Filter.new
      filter.value = "line_items[*].sku"
      filter.verb = "equals"
      filter.regex = "REPLACE ME WITH A SKU"

      handler = Handler.new
      handler.service_name = Handlers::Tagger.to_s
      handler.settings = {
        taggable_type: "Customer",
        taggable_id: "{{ customer.id }}",
        tag_name: "REPLACE ME WITH THE DESIRED TAG NAME",
      }

      rule.filters = [filter]
      rule.handlers = [handler]

      template = new
      template.handle = :tag_customer_on_specific_item
      template.description = "This rule is perfect if you have special items that require special care. Whenever an order contains such item, tag the customer. \
Feel free to enhance with additional actions if you'd like to, say, also get notified by email, or receive an SMS whenever that item is sold"
      template.rule = rule
      template
    end

    def tagger_on_account_creation
      rule = Rule.new
      rule.name = "Tag new customers"
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
      template.description = "Use this rule to tag customers as soon as they get created. This comes handy if you have some sort of approval process."
      template.rule = rule
      template
    end

    def sendgrid_on_shipping_order
      rule = Rule.new
      rule.name = "Email me when an order has shippable goods"
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
      template.description = "This rule will notify you as soon as an order contains an item that requires shipping. Especially handy if you have a mix of digital \
physical goods, and you'd like to be aware whenever a physical good is sold."
      template.rule = rule
      template
    end

    def sms_on_low_inventory
      rule = Rule.new
      rule.name = "SMS on low inventory"
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
      template.description = "This rule can be used to quickly get notified whenever an item's inventory available quantity drops below a certain threshold.\
Simply replace the twilio credentials with your own to get started."
      template.rule = rule
      template
    end
  end
end
