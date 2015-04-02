require 'middleman-aks/article_container'
require 'middleman-aks/site_tree'
require 'middleman-aks/index_creator'
require 'middleman-aks/archives'
require 'middleman-aks/breadcrumbs'
require 'middleman-aks/resource_attributes'

module Middleman
  module Aks
    #
    # == Controller Class Description
    #
    class Controller
      include ERB::Util
#      attr_reader :site_tree
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
      def root
        @app.sitemap.find_resource_by_path("/#{@app.index_file}")
      end
      # for debug
      def _paths
        @app.sitemap.resources.map(&:path)
      end

=begin
      def parentage(page)
        array = []
        prev_parent = page.parent
        while prev_parent
          array << prev_parent
          prev_parent = prev_parent.parent
        end
        array
      end
=end
      def site_tree
        @processors[:site_tree]
      end
      ################
      # return list of directories for resources (sitemap.resource if not specified)
      #
      def directory_list(resources=nil)
        resources ||= @app.sitemap.resources

        hash = {}
        resources.each do | resource |
          dirs = resource.path.split("/")
          dirs.pop
          dirs.inject('') do | result, dir |
            hash[r = "#{result}/#{dir}"] = true
            r
          end
        end

        ## take out brank dir and strip out '^/' 
        return hash.keys.select {|p| p != "" }.map {|p| p.sub(/^\//, '')}
      end
      ################
      def publishable_html_resources(resources=nil)
        resources ||= @app.sitemap.resources
        resources.select {|res| res.ext == ".html" && ! res.ignored? && res.data.published != false}
      end
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
