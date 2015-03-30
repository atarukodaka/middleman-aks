require 'middleman-aks/processor'
require 'rubytree'

module Middleman
  module Aks
    class SiteTree < Processor
      class TreeNode < Tree::TreeNode
        def path
          dir = (parent) ? parentage.map(&:name).reverse.join("/") : "/"
          File.join(dir, name)
        end
      end
      attr_reader :root
      def initialize(app, controller, options = {})
        super
        @root = TreeNode.new('')
      end
      def find_node_by_path(path)
        paths = path.split("/")
        node = @root
        paths.each do |pt|
          node = node[pt]
        end
        node
      end

      def add_node(resource)
        file = resource.path
        node = @root
        ar = File.split(file).first.split("/")
        ar.shift if ar.first == "."
          
        ar << File.split(file).last
        ar.each do | dir |
          if node[dir].nil?
            new_node = TreeNode.new(dir)
            @app.logger.debug " new node '#{dir}' added"
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
#        binding.pry
        @app.content_tag(:ul) do 
          node.children.map do | node |
#            binding.pry
            next if node.name == "index.html" && node.parent 
            @app.content_tag(:li) do # , node.name) #  do
              link = 
                if node["index.html"]   # link to children/index.html
                  @app.link_to(node.name, node["index.html"].path)
                elsif resource = @app.sitemap.find_resource_by_path(node.path)
                  @app.link_to(node.name, resource)
                else
                  node.name
                end
              [link, 
               (node.has_children?) ? render(node) : nil, "\n"].join.html_safe
#              [(resource = @app.sitemap.find_resource_by_path(node.path)) ? @app.link_to(node.name, resource) : node.name,
#               (node.has_children?) ? render(node).to_s : nil, "\n"].join.html_safe
            end
          end.join.html_safe
        end
      end
      def manipulate_resource_list(resources)      
        resources.each do |resource|
          @app.logger.debug "#{resource.path}: ignored? #{resource.ignored?}"
#          binding.pry
          next if resource.ext != ".html" or resource.ignored?
          add_node(resource)          
        end
        resources
      end
    end ## module SiteTree
  end ## module Aks
end ## module Middleman
################################################################

