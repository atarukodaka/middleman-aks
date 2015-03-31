#require 'pry-byebug'
require 'middleman-aks/controller'

module Middleman
  module Aks
    #
    # 
    class Extension < Middleman::Extension
      # == Helper Functions
      #
      helpers do
        # return controller
        #
        def controller
          @_controller
        end
        
        # set controller
        #
        def controller=(controller)
          @_controller = controller
        end
        alias_method :aks, :controller
        # utils
        def page_for(path)
          sitemap.find_resource_by_path(path)
        end
        alias_method :resource_for, :page_for
      end ## helpers

      option :index_template, "/templates/index_template.html"
      option :archives_template_year, "/templates/archives_template_year.html"
      option :archives_template_month, "/templates/archives_template_month.html"
      option :archives_path_year, "/archives/%{year}/index.html"
      option :archives_path_month, "/archives/%{year}/%{month}.html"

      def initialize(app, options_hash={}, &block)
        super
        app.set :aks_settings, options
      end
      
      # == Hooks
      # called after configuraiton
      #
      # let the *controller* run.
      #
      def after_configuration
        app.logger.level = 0
        app.logger.debug "- extension: after_configuration"
#        binding.pry
        #@app.controller = self
        app.controller = Middleman::Aks::Controller.new(app, self)        
        app.controller.run
      end
    end
  end
end
