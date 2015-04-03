#require 'middleman-aks/article_container'
require 'middleman-aks/site_tree'
require 'middleman-aks/index_creator'
require 'middleman-aks/archives'
require 'middleman-aks/breadcrumbs'
require 'middleman-aks/resource_attributes'

module Middleman
  module Aks
    # == Controller Class Description
    #
    class Controller
      include ERB::Util
      #
      def initialize(app, ext)
        @app = app
        @ext = ext
        @processors = {}
        @site_tree = nil
        @pages = []
      end

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
      def manipulate_resource_list(resources)
        @pages = resources.select {|r|
          r.ext == ".html" && ! r.ignored? && r.data.published != true
        }.map {|r|
          r.extend Middleman::Aks::InstanceMethodsToResource 
        }
#        binding.pry
        resources.reject {|r| r.data.published == true}
      end
      def create_page(path, locals={})
        Sitemap::Resource.new(@app.sitemap, path).tap do |p|
          p.add_metadata locals: locals
          p.extend InstanceMethodsToResource
        end
      end
      def create_proxy_page(path, template, locals={})
        create_page(path, locals).tap do |p|
          p.proxy_to(template)
        end
      end
      
      ################
      # create instances of each processors and register manipulators
      #
      # @return [Void]
      def run
        processor_classes = [Archives, IndexCreator, Breadcrumbs, SiteTree]
#        binding.pry
        @processors = {pages: self}
        processor_classes.each {|klass| 
          @processors[klass.to_s.demodulize.underscore.to_sym] = klass.new(@app, self)
        }

=begin
        @_processors = {
          pages: self,
#          article_container: Middleman::Aks::ArticleContainer.new(@app, self),
          archives: Archives.new(@app, self),
#          archives: Middleman::Aks::Archives.new(@app, self),
          index_creator: Middleman::Aks::IndexCreator.new(@app, self),
          breadcrumbs: Middleman::Aks::Breadcrumbs.new(@app, self),
          site_tree: Middleman::Aks::SiteTree.new(@app, self)
        }
=end

        # register manipulators of each processors and helpers if any
        @processors.each do |name, processor|
          @app.sitemap.register_resource_list_manipulator(name, processor) if processor.respond_to? :manipulate_resource_list
#          binding.pry
          if processor.class.const_defined?("Helpers")
            @app.helpers do
              include Object.const_get("#{processor.class}::Helpers")
            end
          end
        end

      end
    end  ## class Controller
  end
end
