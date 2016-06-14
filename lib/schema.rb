class Schema
  class Boolean
    def self.to_s
      'Boolean'
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

    {
      'customers/update' => {
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
    }
  end
end
