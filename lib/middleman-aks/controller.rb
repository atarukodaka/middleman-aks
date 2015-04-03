#require 'middleman-aks/article_container'
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
        @pages = []
      end

      # === Core Attributes
      # Return articles
      #
      # @return [Array]
=begin
      def articles
        @app.logger.warn "run() needs to be called before using 'articles()'" if @processors.empty?
        @processors[:article_container].articles
      end
=end
      def pages
        @pages.sort_by(&:date).reverse
      end
      alias_method :articles, :pages
      def root
        @app.sitemap.find_resource_by_path("/#{@app.index_file}")
      end

      # for debug
      def paths
        @pages.map(&:path)
      end

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
=begin
      def publishable_html_resources(resources=nil)
        resources ||= @app.sitemap.resources
        resources.select {|res| res.ext == ".html" && ! res.ignored? && res.data.published != false}
      end
=end
      ################
      def manipulate_resource_list(resources)
        @pages = resources.select {|r|
          r.ext == ".html" && ! r.ignored? && r.data.published != true
        }.map {|r|
          r.extend Middleman::Aks::InstanceMethodsToResource 
        }
#        binding.pry
        resources.reject {|r| r.data.published == true}
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
          pages: self,
#          article_container: Middleman::Aks::ArticleContainer.new(@app, self),
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
