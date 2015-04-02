require 'middleman-aks/processor'
require 'rubytree'

module Middleman
  module Aks
    ################################################################
    # == SiteTree Class Description
    #
    # This class provies a *SiteTree* class whoes instances contains
    #  a tree of the site managed by Middleman.
    #
    class SiteTree < Processor
      class TreeNode < Tree::TreeNode
        alias_method :resource, :content

        def to_hash
          {
            name: name,
            path: resource.path,
            children: children.map(&:to_hash)
          }
        end
      end
      include ERB::Util

      ################
      # @!attribute [r] root
      # 
      attr_reader :root

      def initialize(app, controller, options = {})
        super
#        @ignore_dirs = options[:ignore_dirs] || []
      end

      ################
      # make_tree
      #
      # @params Array of Sitemap::Resource
      #
      # @return Middleman::SiteTree::TreeNode root node

      def _make_tree(resources)
        @root = TreeNode.new('Home', controller.root)  # set root node at first
        resources.each do | resoure |
          next if resource == controller.root # skip root as its already set before this loop
          dirs = resource.path.split("/")
          dirs.pop   # take out basename
          dirs.pop if File.basename(resource.path) == @app.index_file  # directory index
          
          next if node_for(resource.path)  # skip if already registered

          # check paranges nodes exists on the tree
          node = @root
          dirs.each do | part |
            if node[part].nil?
              new_ndoe = TreeNode.new(part)
              node << new_node
            end
            node = node[part]
          end
        end
      end

      def make_tree(resources)
        # first, make a tree with directory points only
        @root = TreeNode.new('Home', controller.root)  # set root node at first

        # listing up all directory and register into the tree
#        binding.pry
        controller.directory_list(resources).each do | dir |
          next if dir == "."   # skip if its root as alread exists
#          next if ! [@ignore_dirs].flatten.select {|re| dir =~ re }.empty?

          node = @root
#          binding.pry
          ##### "a/b/c" => ['', 'a'] => ['/a', 'b'] => ['/a/b', 'c']
          #dir.split("/").inject('.') do | result, part |  
          dir.split('/').each do | part |
            if node[part].nil?                # if its not registered yet
              new_node = TreeNode.new(part)   # put it into the current node as child
              node << new_node
            end
            node = node[part]
          end
        end

        # second, add nodes with existing resources respectively
        resources.each do | resource |
          next if resource == controller.root
#          next if ! [@ignore_dirs].flatten.select {|re| resource.path =~ re }.empty?

          dirs = File.dirname(resource.path).split("/")
          dirs.pop if dirs.size == 1  && dirs.first == "." # take it out "." as its root
          
          if File.basename(resource.path) == @app.index_file 
            # "a/b/index.html" => ['a']
            dirname = dirs.pop

            node = @root  # parent node
            dirs.each {| dir | node = node[dir] } # ['a', 'b', 'c'] => node['a']['b']['c']
            node[dirname].content = resource  ## ?? the tree shd hv the node
          else
            # "a/b/c.html" => ['a', 'b']

#            binding.pry
            node = @root   # parent node
            dirs.each {| dir | node = node[dir] } # ['a', 'b', 'c'] => node['a']['b']['c']
            name = File.basename(resource.path)
#            new_node = TreeNode.new(name, resource)
#            new_node = TreeNode.new(resource.data.title || name, resource)
            new_node = TreeNode.new(name)
            node << new_node
          end
        end
        # finally, return the root node
        return @root
      end
      
      ################
      # Render the tree.
      #
      # @return [String] rendered string
      def render(node = nil, exclude_dirs = [])
        node ||= @root
        return if ! [exclude_dirs].flatten.select {|re| node.resource.try(:path) =~ re }.empty?

        @app.content_tag(:li) do
          [
           (node.resource) ? @app.link_to(h(node.name), node.resource) : h(node.name),
           @app.content_tag(:ul) do 
             node.children.sort {|a, b|
               a.children.try(:size) <=> b.children.try(:size)
             }.map do |child|
               render(child, exclude_dirs)
             end.join.html_safe
           end
          ].join.html_safe
        end
      end
      ################
      # dump the tree
      #
      def dump(node = nil, indent = nil)
        node ||= @root
        indent ||= 0
        [
         "#{node.name} (#{node.resource.path})",
         node.children.map {|n| dump(n, indent + 1) }
        ].join("\n")
      end
      ################
      # 
      def node_for(resource)
        return @root if resource == controller.root
        
        paths = resource.path.split("/")
        paths.pop if File.basename(resource.path) == @app.index_file

        node = @root
        paths.each do | path |
          node = node[path]
        end
        return node
      end
      def basename(resource)
        return "Home" if resource == root
        bname = File.basename(resource.path)
        if bname == @app.index_file
          File.dirname(resource.path).split("/").last
        else
          bname
        end
      end
      ################
      # Manipulate resource list
      #
      # @param [Middleman::Sitemap::Resource]
      #
      # @return [Array] an array of resources
      def manipulate_resource_list(resources)   
#        make_tree(resources)
        make_tree(resources.select {|res| res.ext == ".html" && ! res.ignored? })
        resources
      end
    end ## class SiteTree
  end ## module Aks
end ## module Middleman
################################################################

