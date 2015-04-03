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
        return resources if @app.resource_for(@template).nil?  # skip if template file does not exist

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
=begin
          newres << Sitemap::Resource.new(@app.sitemap, index_path).tap do |p|
            p.proxy_to(@template)
            p.add_metadata locals: locals
            p.extend Middleman::Aks::InstanceMethodsToResource
          end 
=end
          newres << controller.create_proxy_page(index_path, @template, locals)
        end
        resources + newres
      end
    end ## class IndexCreator
  end
end
