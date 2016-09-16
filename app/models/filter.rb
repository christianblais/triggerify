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

  def valid_for?(content)
    content.strip!
    content.downcase!

    regex.strip!
    regex.downcase!

    case verb
    when 'equals'
      content == regex
    when 'includes'
      content.include?(regex)
    when 'excludes'
      content.exclude?(regex)
    when 'starts_with'
      content.start_with?(regex)
    when 'ends_with'
      content.end_with?(regex)
    when '>'
      content.to_i > regex.to_i
    when '<'
      content.to_i < regex.to_i
    when '>='
      content.to_i >= regex.to_i
    when '<='
      content.to_i <= regex.to_i
    when 'regex'
      content.match(/#{regex}/i)
    end
  end
end
