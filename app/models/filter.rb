class Filter < ActiveRecord::Base
  belongs_to :rule, inverse_of: :filters

  validates :value, presence: true
  validates :regex, presence: true

  def valid?(payload)
    content = Parser.new(payload).parse(value)
    content.match(/#{regex}/i)
  end
end
