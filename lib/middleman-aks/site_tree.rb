require 'middleman-aks/processor'
require 'rubytree'

module Middleman
  module Aks
    class SiteTree < Processor
      class TreeNode < Tree::TreeNode
#        attr_accessor :path
#        def path
        def resource
          content
#          dir = (parent) ? parentage.map(&:name).reverse.join("/") : "/"
#          File.join(dir, name + ((has_children?) ? "/index.html" : ""))
        end
      end
      include ERB::Util

      attr_reader :root
      def initialize(app, controller, options = {})
        super
        @root = TreeNode.new('Home')
      end
=begin
      def add_node(resource)
        file = resource.path
        return if file =~ /\/index\.html$/ || file == "index.html"

        node = @root
        ar = File.split(file).first.split("/")
#        next if File.split(file).last == @app.index_file && ! ar.first == "."
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
=end
      def make_tree(resources)
#        binding.pry
        @root = TreeNode.new('Home', "/index.html")

        resources.map(&:path).each do | file |
          next if file =~ /\/index\.html$/ || file == "index.html"
          node = @root  

          dirs = File.split(file).first.split("/")
          dirs.shift if dirs.first == "."

      #    binding.pry
      #    paths = [dirs, File.split(file).last].flatten
          paths = dirs
          paths.inject ('') do |res, path|
            if node[path].nil?
              new_node = TreeNode.new(path, @app.sitemap.find_resource_by_path([res, path, "index.html"].join("/")))
              node << new_node
              node = new_node
            else
              node = node[path]
            end
            [res, path].join("/")
          end

          new_node = TreeNode.new(File.split(file).last, @app.sitemap.find_resource_by_path(file))
          node << new_node 
        end
        @root
      end
      
      ################
      def render(node = nil)
        node ||= @root
        @app.content_tag(:li) do
#          binding.pry
#          @app.logger.debug("#{node.name}: #{@app.sitemap.find_resource_by_path(node.path).nil?}")
          [
#           (r = @app.sitemap.find_resource_by_path(node.path)) ? @app.link_to(h(node.name), r) : h(node.name),
           (node.resource) ? @app.link_to(h(node.name), node.resource) : h(node.name),
           @app.content_tag(:ul) do 
             node.children.map do |child|
               render(child)
             end.join.html_safe
           end
          ].join.html_safe
        end
      end
      def __render(node = nil)
        node ||= @root
        @app.content_tag(:ul) do 
          node.children.map do | node |
            next if node.name == @app_index_file && node.parent # skip if /index.html
            @app.content_tag(:li) do # , node.name) #  do
              link = 
                if node["index.html"]   # link to children/index.html
                  @app.link_to(node.name, node["index.html"].resource)
                elsif node.resource # resource = @app.sitemap.find_resource_by_path(node.path)
                  @app.link_to(node.name, node.resource)
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
        make_tree(resources.select {|res| res.ext == ".html" && ! res.ignored?})
        return resources
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

