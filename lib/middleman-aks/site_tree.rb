require 'middleman-aks/processor'
require 'rubytree'

module Middleman
  module Aks
    class SiteTree < Processor
      attr_reader :root
      def initialize(app, controller, options = {})
        super
        @root = Tree::TreeNode.new('')
      end
      def add_node(resource)
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
      def render(node = nil)
        node ||= @root
#        binding.pry
=begin
        if node.has_children?
          [@app.content_tag(:h2, node.name),
           node.children.map {|n| render(n)}].join.html_safe
        else
          @app.content_tag(:h3, node.name)
        end
=end
        @app.content_tag(:ul) do 
          node.children.map do | node |
            @app.content_tag(:li) do # , node.name) #  do
              [(node.content.nil?) ? node.name : @app.link_to(node.name, node.content),
               (node.has_children?) ? render(node).to_s : nil].join.html_safe
            end
          end.join.html_safe
        end
      end
      def manipulate_resource_list(resources)      
        resources.each do |resource|
          add_node(resource)          
        end
      end
    end ## module SiteTree
  end ## module Aks
end ## module Middleman
################################################################

