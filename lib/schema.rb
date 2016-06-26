class Schema
  class Boolean
    def self.to_s
      'Boolean'
    end
  end

  class IP
    def self.to_s
      'IP'
    end
  end

  def self.describe
    address = {
      id: Fixnum,
      first_name: String,
      last_name: String,
      company: String,
      address1: String,
      address2: String,
      city: String,
      province: String,
      country: String,
      zip: String,
      phone: String,
      name: String,
      province_code: String,
      country_code: String,
      country_name: String,
      default: Boolean,
    }

    location = address.slice(
      %w(
        id,
        country_code,
        province_code,
        name,
        address1,
        address2,
        city,
        zip,
      )
    )

    customer = {
      id: Fixnum,
      shop_id: Fixnum,
      email: String,
      accepts_marketing: Boolean,
      created_at: DateTime,
      updated_at: DateTime,
      first_name: String,
      last_name: String,
      orders_count: Fixnum,
      state: %w(enabled disabled),
      total_spent: Float,
      last_order_id: Fixnum,
      note: String,
      verified_email: Boolean,
      tax_exempt: Boolean,
      tags: String,
      last_order_name: String,
      default_address: address,
      address: [address]
    }

    line_item = {
      id: Fixnum,
      variant_id: Fixnum,
      title: String,
      quantity: Fixnum,
      price: Float,
      grams: Fixnum,
      sku: String,
      variant_title: String,
      vendor: String,
      fulfillment_service: String,
      product_id: Fixnum,
      requires_shipping: Boolean,
      taxable: Boolean,
      gift_card: Boolean,
      name: String,
      variant_inventory_management: String,
      properties: String,
      product_exists: Boolean,
      fulfillable_quantity: Fixnum,
      total_discount: Float,
      fulfillment_status: String,
      origin_location: location,
      destination_location: location
    }

    shipping_line = {
      id: Fixnum,
      title: String,
      price: Float,
      code: String,
      source: String,
      phone: String,
      delivery_category: String,
      carrier_identifier: String,
    }

    {
      'customers/update': customer,
      'customer/delete': { id: Fixnum },
      'customers/update': customer,

      'orders/create': {
        id: Fixnum,
        email: String,
        closed_at: DateTime,
        created_at: DateTime,
        updated_at: DateTime,
        number: String,
        note: String,
        token: String,
        gateway: String,
        test: Boolean,
        total_price: Float,
        subtotal_price: Float,
        total_weight: Fixnum,
        total_tax: Fixnum,
        taxes_included: Boolean,
        currency: String,
        financial_status: String,
        confirmed: Boolean,
        total_discounts: Float,
        total_line_items_price: Float,
        cart_token: String,
        buyer_accepts_marketing: Boolean,
        name: String,
        referring_site: String,
        landing_site: String,
        cancelled_at: DateTime,
        cancel_reason: String,
        checkout_token: String,
        reference: String,
        user_id: Fixnum,
        location_id: Fixnum,
        source_identifier: String,
        source_url: String,
        processed_at: DateTime,
        device_id: Fixnum,
        browser_ip: IP,
        landing_site_ref: String,
        order_number: String,
        discount_codes: [String],
        note_attributes: String,
        payment_gateway_names: [String],
        processing_method: String,
        checkout_id: Fixnum,
        source_name: String,
        fulfillment_status: String,
        tags: String,
        contact_email: String,
        order_status_url: String,
        line_items: [line_item],
        shipping_lines: [shipping_line],
        shipping_address: address,
        billing_address: address,
        customer: customer,
      }
    }
  end
end
