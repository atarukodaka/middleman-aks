require 'middleman-aks/processor'

module Middleman
  module Aks
    class IndexCreator < Processor
      def initialize(app, ext, options = {})
        super

        @template = app.config.aks_settings.index_template
        @app.ignore @template
      end

      def manipulate_resource_list(resources)
        dirs = controller.directory_list(resources.select {|p| p.ext == ".html" && ! p.ignored?})

        newres = []
#        binding.pry
        dirs.each do | dir |
          index_path = File.join(dir, @app.index_file)
          next if @app.page_for(index_path)  # skip if index already exists

#          binding.pry
          locals = {
            index_path: index_path,
            index_name: dir.split("/").last
          }
          newres << Sitemap::Resource.new(@app.sitemap, index_path).tap do |p|
            p.proxy_to(@template)
            p.add_metadata locals: locals
          end 
        end
        resources + newres
      end
      def __manipulate_resource_list(resources)
        @app.logger.debug "- index_creator.manipulate"       
        # create index file on a certain directory if not exists
        #
        return resources if @app.sitemap.find_resource_by_path(@template).nil?
        paths = {}

        resources.select {|p| p.ext == ".html" && ! p.ignored? && p.path != "/index.html" }.each do |resource|
          @app.logger.debug "res #{resource.path} added to path as new res"
          dirs = File.split(resource.path).first.split("/")
          dirs.each_with_index do |path, i|
            paths[dirs[0..i].join("/")] = true
          end
        end
        paths.delete(".")
        
        newres = []
        paths.keys.each do |path|
          index_path = File.join(path, @app.index_file)
          next if @app.sitemap.find_resource_by_path(index_path) ## skip if an index already exists

          @app.logger.debug "- proxy to #{index_path}"
          
          locals = {
            index_path: index_path,
            index_name: path.split("/")[-1],
          }
          newres << Sitemap::Resource.new(@app.sitemap, index_path).tap do |p|
            p.proxy_to(@template)
            p.add_metadata locals: locals
          end 
        end
        resources + newres
      end
      def create_index_resource
      end
    end ## class IndexCreator
  end
end
