class Filter < ActiveRecord::Base
  belongs_to :rule, inverse_of: :filters

  validates :value, presence: true
  validates :regex, presence: true

  def valid?(payload)
    Rails.logger.info("FILTER: #{value} : #{regex} : #{payload}")
    content = Parser.new(payload).parse(value)
    Rails.logger.info("FILTER: #{content}")
    content.match(/#{regex}/i)
  end
end
