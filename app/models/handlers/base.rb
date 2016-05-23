module Handlers
  class Base
    class << self
      def settings
        @settings ||= []
      end

      def setting(name)
        settings << name

        define_method(name) do
          parser.parse(@settings[name])
        end
      end
    end

    def initialize(settings, payload)
      @settings = settings
      @payload = payload
    end

    private

    def parser
      @parser ||= Parser.new(@payload)
    end
  end
end
