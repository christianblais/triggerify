class Filter < ActiveRecord::Base
  belongs_to :rule, inverse_of: :filters

  validates :value, presence: true
  validates :regex, presence: true

  def valid?(payload)
    return true if value.blank? || regex.blank?
    content = Parser.new(payload).parse(value)
    content.match(/#{regex}/i)
  end
end
