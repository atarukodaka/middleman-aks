require 'pry-byebug'
require 'middleman-aks/controller'
require 'middleman-aks/breadcrumbs'

module Middleman
  module Aks
    class Extension < Middleman::Extension
      # option :foo, :bar
      #self.defined_helpers = []

      helpers do
        def controller
          @_controller
        end
        def controller=(controller)
          @_controller = controller
        end
        
        alias_method :aks, :controller
        include Middleman::Aks::Breadcrumbs::Helpers

      end ## helpers

      option :index_template, "/index_template.html"
      option :archives_template_year, "/archives_template_year.html"
      option :archives_template_month, "/archives_template_month.html"
      option :archives_path_year, "/archives/%{year}/index.html"
      option :archives_path_month, "/archives/%{year}/%{month}.html"

      def initialize(app, options_hash={}, &block)
        super
        app.set :aks_settings, options
      end
      
=begin
      def articles
        @article_container.articles
      end
=end
      def after_configuration
        app.logger.debug "- extension: after_configuration"
#        binding.pry
        #@app.controller = self
        app.controller = Middleman::Aks::Controller.new(app, self)        
        app.controller.run
      end
    end
  end
end
