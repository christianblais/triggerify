module Handlers
  class UserError < StandardError; end

  class Base
    class << self
      def label(label = nil)
        @label = label if label
        @label
      end

      def description(description = nil)
        @description = description if description
        @description
      end

      def deprecated!
        @deprecated = true
      end

      def deprecated?
        !!@deprecated
      end

      def settings
        @settings ||= {}
      end

      def setting(name, options = {})
        settings[name] = options

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
