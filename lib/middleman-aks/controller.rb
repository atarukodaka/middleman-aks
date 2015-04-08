require 'middleman-aks/site_tree'
require 'middleman-aks/index_creator'
require 'middleman-aks/archives'
require 'middleman-aks/breadcrumbs'
#require 'middleman-aks/page_attributes'

module Middleman
  module Aks
    # == Controller Class Description
    #
    class Controller
      include ERB::Util
      #
      
      attr_reader :app, :processors
      def initialize(app, ext)
        @app = app
        @ext = ext
        @processors = {}
      end

      ################
      # attribugtes

#      attr_reader :pages
      def pages(resources=nil)
        resources ||= app.sitemap.resources
        resources.select {|r|
          r.ext == '.html' && ! r.ignored? && r.data.published != false
        }
      end
#      alias_method :articles, :pages

      def top_page
        app.sitemap.find_resource_by_path("/#{@app.index_file}")
      end
#      alias_method :root_page, :root

      def site_tree
        @processors[:site_tree]
      end

      ################
      # return list of directories for resources (sitemap.resource if not specified)
      #
      def directory_list(resources = nil)
        resources ||= @app.sitemap.resources

        ar = []
        resources.each do | resource |
          dirs = resource.path.split('/')
          dirs.pop
          dirs.inject([]) do | result, dir |
            ar.tap {|a| a << [result.last, dir].join('/')}
          end
        end

        ## take out brank dir and strip out '^/' 
#        return hash.keys.select {|p| p != '' }.map {|p| p.sub(/^\//, '')}
        return ar.select {|p| p != '' }.map {|p| p.sub(/^\//, '')}.uniq
      end
      ################
      def manipulate_resource_list(resources)
=begin
        # extend page attributes into each pages

        @pages = resources.select {|r|
          r.ext == '.html' && ! r.ignored? && r.data.published != false
        }.map {|r|
          r.extend PageAttributes::InstanceMethodsToResource 
        }
=end
        # return pages excluding unpublished one
        resources.reject {|r| r.data.published == false}

      end

      ################
      # create new page to the given path
      #
      def create_page(path, data = {})
        Sitemap::Resource.new(@app.sitemap, path).tap do |p|
          p.add_metadata data if ! data.empty?
          #          p.add_metadata locals: locals
#          p.extend PageAttributes::InstanceMethodsToResource 
        end
      end
      def create_proxy_page(path, template, data={})
        create_page(path, data).tap do |p|
          p.proxy_to(template)
        end
      end
      
      ################
      def register_processor(name, processor)
        @processors[name] = processor
      end

      ################
      def ready
        @processors.each do |name, processor|
          if processor.respond_to? :ready
            @app.ready do
              processor.ready
            end
          end
        end
      end

      ################
      # create instances of each processors and register manipulators
      #
      # this will be called from after_configuration hook on extension 
      #
      def after_configuration
        processor_classes = [Archives, IndexCreator, Breadcrumbs, SiteTree]

        # register manipulator of this class first
        @app.sitemap.register_resource_list_manipulator(:pages, self)

        processor_classes.each {|klass| 
#          @processors[klass.to_s.demodulize.underscore.to_sym] = klass.new(@app, self)
          register_processor(klass.to_s.demodulize.underscore.to_sym, klass.new(@app, self))
        }

        # register manipulators of each processors and helpers if any
        #
        @processors.each do |name, processor|
          @app.sitemap.register_resource_list_manipulator(name, processor) if processor.respond_to? :manipulate_resource_list
          if processor.class.const_defined?('Helpers')
            @app.helpers do
              #include Object.const_get("#{processor.class}::Helpers")
              include "#{processor.class}::Helpers".constantize
            end
          end
        end
      end
    end  ## class Controller
  end
end
################################################################
