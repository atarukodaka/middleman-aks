module Middleman
  module Aks
    class Processor
      def initialize(_app, ext, options = {})
        @app = _app
        @ext = ext
        @options = options
      end

      def manipulate_resource_list(resources)
        resources
      end
    end
  end
end
