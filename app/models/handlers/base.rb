module Handlers
  class Base
    attr_reader :settings

    def initialize(settings)
      @settings = settings
    end
  end
end
