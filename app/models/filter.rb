class Filter < ActiveRecord::Base
  belongs_to :rule, inverse_of: :filters

  validates :value, presence: true
  validates :regex, presence: true

  def valid?(payload)
    value = Parser.new(payload).parse(value)
    Rails.logger.info("#{value}, #{regex}")
    value.match(/#{regex}/i)
  end
end
