#require 'pry-byebug'
require 'middleman-aks/controller'

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

      option :index_template, "/templates/index_template.html"
      option :archives_template_year, "/templates/archives_template_year.html"
      option :archives_template_month, "/templates/archives_template_month.html"
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

################################################################
=begin
require 'rubytree'

module Middleman
  module Aks
    class SiteTree
      def render
      end
      class Extension < Middleman::Extension
        helpers do
          def sitetree
            
          end
        end
        
        def initialize(app, options_hash={}, &block)
          super
          @root = Tree::TreeNode.new('')
        end
        def after_configuration
          @app.register_resource_list_manipulator(:sitetree, self)
        end
        def manipulate_resource_list(resources)
          raise
        end
      end ## class Extension
    end ## module SiteTree
  end ## module Aks
end ## module Middelamn

Middleman::Aks::SiteTree::Extension.register(:sitetree)
=end
