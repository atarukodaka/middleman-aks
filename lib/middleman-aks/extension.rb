require 'middleman-aks/controller'

module Middleman
  module Aks
    class Extension < Middleman::Extension
      helpers do
=begin
        def controller
          @_controller
        end
        
        def controller=(controller)
          @_controller = controller
        end
        alias_method :aks, :controller
=end
        def aks
          @_controller
        end
        
        def aks=(controller)
          @_controller = controller
        end

        # utils
        def page_for(path)
          sitemap.find_resource_by_path(path)
        end
        alias_method :resource_for, :page_for
      end ## helpers

      #
      # option settings
      #
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
        app.logger.level = 0   ## yet: debug
        app.logger.debug "- extension: after_configuration"

#        app.controller = Middleman::Aks::Controller.new(app, self).tap {|c| c.run}
        app.aks = Middleman::Aks::Controller.new(app, self).tap {|c| c.run}
      end
    end
  end
end
