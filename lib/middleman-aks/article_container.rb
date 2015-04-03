require 'middleman-aks/processor'

module Middleman
  module Aks
    class ArticleContainer < Processor
      ################
      def initialize(app, ext, option = {})
        super
        @articles = []
      end
      def articles
        @articles.sort_by(&:date).reverse
      end
      def manipulate_resource_list(resources)
        @app.logger.debug "- article_container.manipulate"

        @articles = resources.select {|r| 
          r.ext == ".html" && ! r.ignored? && r.data.published != false
        }
        #resources.reject {|r| r.data.published == false}
        resources.select {|r| r.data.published != false}.map do |r|
          r.extend Middleman::Aks::InstanceMethodsToResource
        end
      end
    end ## class ArticleContainer
  end
end

