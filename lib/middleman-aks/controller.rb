require 'middleman-aks/article_container'
require 'middleman-aks/site_tree'
require 'middleman-aks/index_creator'
require 'middleman-aks/archives'
require 'middleman-aks/breadcrumbs'

require 'tree'

module Middleman
  module Aks
    #
    # == Controller Class Description
    #
    class Controller
      attr_reader :site_tree
      #
      #
      def initialize(app, ext)
        @app = app
        @ext = ext
        @processors = {}
        @site_tree = nil
      end

      # === Core Attributes
      # Return articles
      #
      # @return [Array]
      def articles
        @app.logger.warn "run() needs to be called before using 'articles()'" if @processors.empty?
        @processors[:article_container].articles
      end

      def sitetree
        @processors[:site_tree]
      end

      # @! 
      #
      # === 
      # create instances of each processors and register manipulators
      #
      # @return [Void]
      def run
        #@app.send(:extend, Middleman::Aks::Breadcrumbs::Helpers)
        #@app.extend Middleman::Aks::Breadcrumbs::Helpers
        @app.helpers do
          include Middleman::Aks::Breadcrumbs::Helpers
        end

        @processors = {
          article_container: Middleman::Aks::ArticleContainer.new(@app, self),
          archives: Middleman::Aks::Archives.new(@app, self),
          index_creator: Middleman::Aks::IndexCreator.new(@app, self),
          site_tree: Middleman::Aks::SiteTree.new(@app, self)
        }
        @processors.each do |name, processor|
          @app.sitemap.register_resource_list_manipulator(name, processor)
        end
      end
    end  ## class Controller
  end
end
