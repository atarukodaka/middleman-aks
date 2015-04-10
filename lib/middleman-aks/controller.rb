require 'middleman-aks/site_tree'
require 'middleman-aks/index_creator'
require 'middleman-aks/archives'
require 'middleman-aks/page_attributes'

module Middleman
  module Aks
    # == Controller Class Description
    #
    class Controller
      include ERB::Util
      
      attr_reader :app, :site_tree, :archives, :index_creator

      def initialize(app, ext)
        @app = app
        @ext = ext

        ## set hooks
        app.sitemap.register_resource_list_manipulator(:pages, self)
        
        ## set processors
        @site_tree = Middleman::Aks::SiteTree.new(app, self)
        @archives = Middleman::Aks::Archives.new(app, self)
        @index_creator = Middleman::Aks::IndexCreator.new(app, self)

        ## set helpers
=begin
        app.helpers do
          #include Middleman::Aks::Breadcrumbs::Helpers
          include Middleman::Aks::SiteTree::Helpers
          include Middleman::Aks::Archives::Helpers
        end
=end        
        ## activate
        Middleman::Aks::PageAttributes.activate
      end

      ################
      # pages, directory utils
      #
      def pages(resources=nil)
        resources ||= app.sitemap.resources
        resources.select {|r|
          r.ext == '.html' && ! r.ignored? && r.data.published != false
        }
      end
      # return list of directories for resources (sitemap.resource if not specified)
      #
      def directory_list(resources = nil)
        resources ||= pages()

        #ar = ['/']
        ar = []
        resources.each do | resource |
          dirs = resource.path.split('/')
          dirs.pop     # take out basename
          dirs.inject([]) do | result, dir |
            ar.tap {|a| a << [result.last, dir].join('/')}
          end
        end

        ## take out brank dir
        #return ar.select {|p| p != '' }.map {|p| p.sub(/^\//, '')}.uniq
        return ar.map {|p| p.sub(/^\//, '')}.uniq
      end
      ################
      # create new page to the given path
      #
      def create_page(path, data = {})
        Sitemap::Resource.new(app.sitemap, path).tap do |p|
          p.add_metadata data if ! data.empty?
        end
      end
      def create_proxy_page(path, template, data = {})
        create_page(path, data).tap do |p|
          p.proxy_to(template)
        end
      end

      ################
      # hooks / resource manipulating
      #
=begin
      def after_configuration
        [archives, index_creator].each do | processor |
          name = processor.class.to_s.demodulize.underscore.to_sym
          app.sitemap.register_resource_list_manipulator(name, processor)
        end
      end
=end
      ################
      def manipulate_resource_list(resources)
        # return pages excluding unpublished one
        resources.reject {|r| r.data.published == false}
      end
    end  ## class Controller
  end
end
################################################################
