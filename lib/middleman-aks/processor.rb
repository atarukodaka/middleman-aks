module Middleman
  module Aks
    class Processor
      # base class to process the feature, mainly manipulate resource list
      #
      attr_reader :app, :controller
      def initialize(app, controller, options = {})
        @app = app
        @controller = controller
        @options = options
=begin
        @app.after_configuration do
          after_configuration()
        end
=end
      end
=begin
      def after_configuration
        if self.class.const_defined?('Helpers')
          app.helpers do
            include "#{self.class}::Helpers".constantize
          end
        end
      end
=end
      def logger
        @app.logger
      end
      # to be implemented in derived class
      def manipulate_resource_list(resources)
        resources
      end
      def page_for(path)
        #@app.sitemap.find_resource_by_path(path)
        @app.page_for(path)
      end
    end ## class Processor
  end
end
