require 'middleman-aks/processor'
require 'rubytree'

module Middleman
  module Aks
    module ArticleTree
      def initialize
        
      end        
    end ## module Tree
  end ## module Aks
end ## module Middleman
################################################################

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
#        @tree = Middleman::
        @root = Tree::TreeNode.new('')
      end
      def articles
        @articles.sort_by(&:date).reverse
      end
      def show_node(node = nil)
        node ||= @root

#        binding.pry
        ["<ul>",
         node.children.map do |node|
           ["<li>",
            node.name,
            (node.has_children?) ? show_node(node) : nil].join.html_safe
         end,
         "</ul>"].join
=begin
        content_tag(:ul) do 
          node.children.each do | node |
            content_tag(:li) do
              [node.name,
               (node.has_children?) ? show(node) : nil].join.html_safe
            end
          end
        end
=end
      end

      def make_node(resource)
        file = resource.path
        node = @root
        ar = File.split(file).first.split("/")
        ar.shift if ar.first == "."
          
        ar << File.split(file).last
        ar.each do | dir |
          if node[dir].nil?
            new_node = Tree::TreeNode.new(dir, resource)
            node << new_node
            node = new_node
          else
            node = node[dir]
          end
        end
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
            make_node(resource)
#            @tree.add_node(resource)
          end
          used_resources << resource
        end
#        binding.pry
        used_resources
      end
    end ## class ArticleContainer
  end
end
