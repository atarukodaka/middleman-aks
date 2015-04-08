require 'middleman-aks/processor'

module Middleman
  module Aks
    # == IndexCreator Class
    #
    # an instance of this class creates directory index page automatically on the
    # same directory of any pages:
    # e.g. /hobby/sports.html exists, create /hobby/index.html (if the file not exists)
    #
    class IndexCreator < Processor
      def initialize(app, controller, options = {})
        super

        @template = app.config.aks_settings.index_template
        @app.ignore @template
      end

      def manipulate_resource_list(resources)
        # skip if template file does not exist
        return resources if @app.resource_for(@template).nil?  

        dirs = controller.directory_list(controller.pages)
        
        newres = []

        dirs.each do | dir |
          index_path = File.join(dir, @app.index_file)
          # skip if an index already exists
          next if ! resources.find {|r| r.path == index_path}.nil?

          locals = {
            index_path: index_path,
            index_name: dir.split('/').last
          }
          newres <<
            controller.create_proxy_page(index_path, @template, locals: locals).tap {|p|
            controller.pages << p
          }
        end
        resources + newres
      end
    end ## class IndexCreator
  end
end
################################################################
