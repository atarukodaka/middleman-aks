require 'middleman-aks/controller'

module Middleman
  module Aks
    class Extension < Middleman::Extension
      helpers do
        include ::Middleman::Aks::Utils
        
        def aks_controller
          @_aks_controller
        end
        
        def aks_controller=(controller)
          @_aks_controller = controller
        end
        alias_method :aks, :aks_controller
        alias_method :aks=, :aks_controller=
        # utils

        def page_for(path)
          sitemap.find_resource_by_path(path)
        end
        alias_method :resource_for, :page_for


        ################
        # return title of the page
        # /index.html => "Home"
        # /foo/index.html => "foo"  (as its directory index)
        # /foo/bar.html => "bar"
        #

      end ## helpers

      #
      # option settings
      #
      option :index_template, "/templates/index_template.html"
      option :archives_template_year, "/templates/archives_template_year.html"
      option :archives_template_month, "/templates/archives_template_month.html"
      option :archives_path_year, "/archives/%{year}/index.html"
      option :archives_path_month, "/archives/%{year}/%{month}.html"

      def initialize(klass, options_hash={}, &block)
        # called on the loading config.rb. configuration are not completed yet.
        super
#        binding.pry
        klass.set :aks_settings, options
        $stderr.puts "** aks::extension.initialize"

#        _app.aks = Middleman::Aks::Controller.new(app, self).tap {|c| c.after_configuration}
      end
      
      # == Hooks
      # called after configuraiton
      #
      # let the *controller* run.
      #
      def after_configuration
#        app.logger.level = 0   ## yet: debug
#        app.logger.debug "- extension: after_configuration"

        app.aks = Middleman::Aks::Controller.new(app, self)
=begin
        app.aks = Middleman::Aks::Controller.new(app, self).tap {|c|
          c.after_configuration
          app.ready do 
            c.ready
          end
        }
=end
      end
    end
  end
end
