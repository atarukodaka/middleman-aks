require 'middleman-aks/article_container'
require 'middleman-aks/site_tree'
require 'middleman-aks/index_creator'
require 'middleman-aks/archives'

require 'tree'

module Middleman
  module Aks
    class Controller
      def initialize(app, ext)
        @app = app
        @ext = ext
        @processors = {}
      end

      def articles
        @app.logger.warn "run() needs to be called before using 'articles()'" if @processors.empty?
        @processors[:article_container].articles
      end
      def show_tree
#        binding.pry
#        @app.logger.debug "show tree:"
#        t = @processors[:article_container].show_node
        @processors[:site_tree].render
      end
      
      def run
        @processors = {
          article_container: Middleman::Aks::ArticleContainer.new(@app, self),
          site_tree: Middleman::Aks::SiteTree.new(@app, self),
          archives: Middleman::Aks::Archives.new(@app, self),
          index_creator: Middleman::Aks::IndexCreator.new(@app, self)
        }
        @processors.each do |name, processor|
          @app.sitemap.register_resource_list_manipulator(name, processor)
        end
      end
    end  ## class Controller
  end
end
