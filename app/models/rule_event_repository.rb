class RuleEventRepository
  class << self
    def dump(object)
      object.dump
    end

    def load(data)
      return new if data.nil?

      object = allocate
      object.instance_variable_set(:@events, data.map { RuleEvent.load(_1) })
      object
    end
  end

  include Enumerable

  EVENTS_TO_KEEP = 10

  def initialize
    @events = []
  end

  def each(&block)
    @events.each(&block)
  end

  def add_event(event)
    @events = @events.push(event).last(EVENTS_TO_KEEP)
  end

  def dump
    @events.map(&:dump)
  end
end
