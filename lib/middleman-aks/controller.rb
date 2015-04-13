=begin
require 'middleman-aks/page_attributes'
require 'middleman-aks/site_tree'
require 'middleman-aks/directory_index_creator'
require 'middleman-aks/archive_manager'
require 'middleman-aks/tag_manager'
=end
require 'middleman-aks/category_manager'

module Middleman
  module Aks
    # == Controller Class Description
    #
    class Controller
      include ERB::Util
      
      attr_reader :app, :ext, :processors
      delegate :options, to: :ext
      
      def initialize(app, ext)
        @app = app
        @ext = ext

        ## set hooks
#        app.sitemap.register_resource_list_manipulator(:pages, self)
        
        ## set processors
        require 'ostruct'
        @processors =
          OpenStruct.new(category_manager: CategoryManager.new(app, self))
=begin
        OpenStruct.new(site_tree: SiteTree.new(app, self),
                         archives: ArchiveManager.new(app, self),
                         tag_manager: TagManager.new(app, self),
                         directory_index_creator: DirectoryIndexCreator.new(app, self))
=end
      end

      ################
      # pages, directory utils
      #
=begin
      def pages(resources=nil)
        resources ||= app.sitemap.resources
        resources.select {|r|
          r.ext == '.html' && ! r.ignored? && r.data.published != false
        }
      end
=end
      # return list of directories for resources (sitemap.resource if not specified)
      #
=begin
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
=end
=begin
      def root_node
        processors.site_tree.root
      end

      def site_tree
        processors.site_tree
      end
      def tags
        processors.tag_manager.tags
      end
=end
      ################
      # create new page to the given path
      #
=begin
      def create_page(path, source=nil, data = {})
        Sitemap::Resource.new(app.sitemap, path, source).tap do |p|
          p.add_metadata data if ! data.empty?
        end
      end
      def create_proxy_page(path, template, source=nil, data = {})
        create_page(path, source, data).tap do |p|
          p.proxy_to(template)
        end
      end
=end
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
=begin
      def manipulate_resource_list(resources)
        # return pages excluding unpublished one
        resources.reject {|r| r.data.published == false}
      end
=end
    end  ## class Controller
  end
end
################################################################
