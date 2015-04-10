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

        bind_helpers
        bind_after_configuration
        bind_ready
      end
      
      protected
      
      def bind_helpers
        if self.class.const_defined? :Helpers
          klass = Object.const_get "#{self.class}::Helpers"
          app.helpers do
            include klass
          end
        end
      end
      ## after_configuration hook
      def bind_after_configuration  
        processor = self
        app.after_configuration do
          processor.after_configuration if processor.respond_to? :after_configuration

          if processor.respond_to? :manipulate_resource_list
            name = processor.class.to_s.demodulize.underscore.to_sym
            processor.app.sitemap.register_resource_list_manipulator(name, processor)
          end
        end
      end
      def bind_ready
        ## ready hook
        if respond_to? :ready
          processor = self
          app.ready do
            processor.ready
          end
        end
      end
    end ## class Processor
  end
end
################################################################
