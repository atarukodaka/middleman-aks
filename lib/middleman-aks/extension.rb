require 'middleman-aks/controller'

module Middleman
  module Aks
  end
end

module Middleman
  module Aks
    class Extension < Middleman::Extension
      ################
      helpers do
        # general utils
        def page_for(path)
          sitemap.find_resource_by_path(path)
        end
        alias_method :resource_for, :page_for
        def link_to_page(page)
          link_to(page.title, page)
        end


        # controller accessors
        def aks_controller
          @_aks_controller
        end
        
        def aks_controller=(controller)
          @_aks_controller = controller
        end
        alias_method :aks, :aks_controller
        alias_method :aks=, :aks_controller=
          
      end ## helpers

      ################
      # option settings
      #
      option :index_template, "/templates/index_template.html"
      option :archives_template_year, "/templates/archives_template_year.html"
      option :archives_template_month, "/templates/archives_template_month.html"
      option :archives_path_year, "/archives/%{year}/index.html"
      option :archives_path_month, "/archives/%{year}/%{month}.html"

      def initialize(klass, options_hash={}, &block)
        super
        klass.set :aks_settings, options
      end
      
      ################
      # Hooks
      def after_configuration
        app.logger.level = 0   ## yet: debug
        app.logger.debug "- extension: after_configuration"

        app.aks = Middleman::Aks::Controller.new(app, self)
      end
    end
  end
end
