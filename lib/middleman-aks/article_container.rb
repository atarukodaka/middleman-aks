require 'middleman-aks/processor'

module Middleman
  module Aks
    class ArticleContainer < Processor
      module InstanceMethodsToResource
        def title
          data.title || metadata[:page]["title"] || ((dir, fname = File.split(path); fname == app.index_file) ? File.split(path).first.split("/")[-1] : fname.sub(/\.html$/, "")) || "[untitled...]"
        end
        def ctime
          File.exists?(source_file) ? File.ctime(source_file) : Time.now
        end
        def mtime
          File.exists?(source_file) ? File.mtime(source_file) : Time.now
        end
        def date
          (data.date) ? (data.date.is_a? Date) ? data.date :  Date.parse(data.date) : ctime.to_date
        end
      end
      ################
      def initialize(app, ext, option = {})
        super
        @articles = []
#        @tree = Middleman::Aks::SiteTree.new
#        @root = Tree::TreeNode.new('')
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
            resource.extend InstanceMethodsToResource
            @articles << resource
#            make_node(resource)
          end
          used_resources << resource
        end
#        binding.pry
        used_resources
      end
    end ## class ArticleContainer
  end
end
