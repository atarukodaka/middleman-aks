module Middleman
  module Aks
    class Processor
      # base class to process the feature, mainly manipulate resource list
      #
      def initialize(app, controller, options = {})
        @app = app
        @controller = controller
        @options = options
      end

      # to be implemented in derived class
      def manipulate_resource_list(resources)
        resources
      end
    end ## class Processor
  end
end
