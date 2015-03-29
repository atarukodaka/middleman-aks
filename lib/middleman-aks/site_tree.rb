require 'middleman-aks/processor'
require 'rubytree'

module Middleman
  module Aks
    class SiteTree < Processor
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
        ["<ul>",
         node.children.map do |node|
           ["<li>",
            node.name,
            (node.has_children?) ? render(node) : nil].join.html_safe
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
      def manipulate_resource_list(resources)      
        resources.each do |resource|
          add_node(resource)          
        end
      end
    end ## module SiteTree
  end ## module Aks
end ## module Middleman
################################################################

