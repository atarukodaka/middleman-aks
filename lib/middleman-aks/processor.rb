module Middleman
  module Aks
    class Processor
      include ERB::Util

      # base class to process the feature, mainly manipulate resource list
      #
      attr_reader :app, :controller
      def initialize(app, controller, options = {})
        @app = app
        @controller = controller
        @options = options
        
      end
      def logger
        @app.logger
      end
      # to be implemented in derived class
      def manipulate_resource_list(resources)
        resources
      end
    end ## class Processor
  end
end
