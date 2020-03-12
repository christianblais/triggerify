class Filter < ActiveRecord::Base
  VERBS = {
    'equals' => 'Equals',
    'includes' => 'Contains',
    'excludes' => 'Excludes',
    'starts_with' => 'Starts with',
    'ends_with' => 'Ends with',
    '>' => 'Greater than',
    '<' => 'Lesser than',
    '>=' => 'Greater or equal to',
    '<=' => 'Lesser or equal to',
    'regex' => 'Regex',
  }

  belongs_to :rule, inverse_of: :filters

  validates :value, presence: true
  validates :verb, presence: true, inclusion: VERBS.keys
  validates :regex, presence: true

  def valid_for?(parsed, content)
    content = content.dup
    content.strip!
    content.downcase!

    parsed.strip!
    parsed.downcase!

    case verb
    when 'equals'
      content == parsed
    when 'includes'
      content.include?(parsed)
    when 'excludes'
      content.exclude?(parsed)
    when 'starts_with'
      content.start_with?(parsed)
    when 'ends_with'
      content.end_with?(parsed)
    when '>'
      content.to_i > parsed.to_i
    when '<'
      content.to_i < parsed.to_i
    when '>='
      content.to_i >= parsed.to_i
    when '<='
      content.to_i <= parsed.to_i
    when 'regex'
      content.match(/#{parsed}/i)
    end
  end
end
