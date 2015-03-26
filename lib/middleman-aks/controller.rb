require 'middleman-aks/article'

module Middleman
  module Aks
    class Controller
      def initialize(app, ext)
        @app = app
        @ext = ext

        @_articles = []


      end
      def articles
        @_articles.sort_by(&:date).reverse
      end
      
      def after_configuration
#        binding.pry
      end

      def manipulate_resource_list(resources)
        @app.logger.debug "- controller.manipulate"
        @_articles = []
        used_resources = []

        resources.each do |resource|
          if resource.ignored?
            used_resources << resource
            next
          elsif resource.data.published == false
            next
          elsif resource.ext == ".html" ## yet: proxy? ??
            resource.extend Middleman::Aks::Article
            @_articles << resource
          end
          used_resources << resource
        end
        used_resources
      end
    end
  end
end
