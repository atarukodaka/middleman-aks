require 'middleman-aks/controller'
require 'middleman-aks/article_accessor'
require 'middleman-aks/article_container'
require 'middleman-aks/archives'
require 'middleman-aks/index_creator'


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
        
      end ## helpers

      option :index_template, "/index_template.html"
      option :archives_template_year
      option :archives_template_month
      option :archives_path_year
      option :archives_path_month

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
        #@app.controller = self
        app.controller = Middleman::Aks::Controller.new(app, self)        
        app.controller.run
      end
    end
  end
end
