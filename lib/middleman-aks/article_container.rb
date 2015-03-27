require 'middleman-aks/processor'
require 'middleman-aks/article_accessor'

module Middleman
  module Aks
    class ArticleContainer < Processor
      def initialize(app, ext, option = {})
        super
        @articles = []
      end
      def articles
        @articles.sort_by(&:date).reverse
      end
      def manipulate_resource_list(resources)
        @app.logger.debug "- article_container.manipulate"
        @articles = []
        used_resources = []


#        binding.pry
        resources.each do |resource|
          if resource.ignored?
            used_resources << resource
            next
          elsif resource.data.published == false
            next
          elsif resource.ext == ".html" ## yet: proxy? ??
            resource.extend Middleman::Aks::ArticleAccessor::InstanceMethodsToResource
            @articles << resource
          end
          used_resources << resource
        end
        used_resources
      end
    end ## class ArticleContainer
  end
end
