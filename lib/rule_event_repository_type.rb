class RuleEventRepositoryType < ActiveModel::Type::Value
  def type
    :json
  end

  def cast_value(value)
    RuleEventRepository.load(ActiveSupport::JSON.decode(value))
  end

  def serialize(value)
    ActiveSupport::JSON.encode(value.dump)
  end

  def changed_in_place?(raw_old_value, new_value)
    cast_value(raw_old_value) != new_value
  end
end
