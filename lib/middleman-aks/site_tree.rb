require 'middleman-aks/processor'
require 'rubytree'

module Middleman
  module Aks
    # == SiteTree Class Description
    #
    # This class provies a *SiteTree* class whoes instances contains a tree of the site managed by Middleman.
    #
    # @author Ataru Kodaka
    class SiteTree < Processor
      # == TreeNode
      #
      class TreeNode < Tree::TreeNode
        # @! group 
        def resource
          content
        end
      end
      include ERB::Util

      # @!group Core Attributes

      # @!attribute [r] root
      # 
      attr_reader :root


      # @!group Tree Creation

      def initialize(app, controller, options = {})
        super
      end
      def make_tree(resources)
#        binding.pry
        @root = TreeNode.new('Home', @app.sitemap.find_resource_by_path("/#{@app.index_file}"))

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
      # Render the tree.
      #
      # @return [String] rendered string
      def render(node = nil)
#        binding.pry
        node ||= @root
        @app.content_tag(:li) do
#          binding.pry
          
          [
           (node.resource) ? @app.link_to(h(node.name), node.resource) : h(node.name),
           @app.content_tag(:ul) do 
#             binding.pry
             node.children.sort {|a, b| a.children.try(:size) <=> b.children.try(:size)}.map do |child|
               render(child)
             end.join.html_safe
           end
          ].join.html_safe
        end
      end
      
      # Manipulate resource list
      #
      # @param [Middleman::Sitemap::Resource]
      #
      # @return [Array] an array of resources
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

