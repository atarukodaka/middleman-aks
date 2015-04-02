require 'middleman-aks/processor'
require 'rubytree'

module Middleman
  module Aks
    ################################################################
    # == SiteTree Class Description
    #
    # create a tree from the given resources.
    #
    class SiteTree < Processor
      include ERB::Util

      # node class
      class TreeNode < Tree::TreeNode
        alias_method :resource, :content

        def to_hash
          hash = {
            name: name,
            title: resource.try(:title),
            path: resource.try(:path)
            #,
            # children: children.map(&:to_hash)
          }
          hash[:children] =  children.map(&:to_hash) if has_children?
          hash
        end
      end

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
=begin
      def _make_tree(resources)
        @root = TreeNode.new('Home', controller.root)  # set root node at first
        resources.each do | resoure |
          next if resource == controller.root # skip root as its already set before this loop
          dirs = resource.path.split("/")
          dirs.pop   # take out basename
          dirs.pop if resource.directory_index?
          
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
=end

      def make_tree(resources)
        # first, make a tree with directory points only
        @root = TreeNode.new('Home', controller.root)  # set root node at first

        # listing up all directory and register into the tree
#        binding.pry
        controller.directory_list(resources).each do | dir |
          next if dir == "."   # skip if its root as alread registered before this loop

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
          
#          if File.basename(resource.path) == @app.index_file 
          if resource.directory_index?
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
            new_node = TreeNode.new(name, resource)
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
      def render(node = nil, options = {})
        node ||= @root
        depth = options[:depth] || 0
        num = options[:num] || 0
#        @_count = (@_count.to_i + 1) % 1000
        collapse = 'collapse' + ((depth <=1 ) ? ' in' : '')

        return if ! [options[:exclude_dirs]].flatten.select {|re| node.resource.try(:path) =~ re }.empty?

        target_id = "menu_#{depth}_#{num}"
        @app.content_tag(:li, :class=>(node.try(:resource) == @app.current_resource) ? 'active' : '') do
          [
           (node.has_children?) ? @app.content_tag(:a, "[+] ", 'data-toggle'=>'collapse', 'data-target'=>"##{target_id}", :style=>'cursor: pointer') : '',
           (node.resource && node.resource != current_resource) ? @app.link_to(h(node.resource.title), node.resource) : h(node.name),
           @app.content_tag(:ul, :class=>collapse, :id=>target_id) do 
             node.children.sort {|a, b|
               a.children.try(:size) <=> b.children.try(:size)
             }.map do |child|
               render(child, exclude_dirs: options[:exclude_dirs], depth: depth+1, num: num).tap { num = num + 1 }
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
        space = Array.new(indent * 2){" "}.join
        [
         "#{space}#{node.name} (#{node.resource.path})\n",
         node.children.map {|n| space + dump(n, indent + 1) }
        ].join()
      end
      ################
      # 
      def node_for(resource)
        return @root if resource == controller.root
        
        paths = resource.path.split("/")
        paths.pop if resource.directory_index? # File.basename(resource.path) == @app.index_file

        node = @root
        paths.each do | path |
          node = node[path]
        end
        return node
      end
      def basename(resource)
#        return "Home" if resource == root
#        bname = File.basename(resource.path)
#        if bname == @app.index_file
        if resource == root
          "Home"
        elsif resource.directory_index?
          File.dirname(resource.path).split("/").last
        else
          File.basename(resource.path)
        end
      end
      ################
      def make_sitemap_yml(node=nil)
        node ||= root

        ## output to sitemap.yml
        dir = app.config.data_dir
        Dir.mkdir(dir) if ! File.directory?(dir)
#        dir = app.config.build_dir
        yml_filename = File.join(dir, 'sitemap.yml')

        File.open(yml_filename, "w") do |f|
          f.write(node.to_hash.to_yaml)
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
        make_tree(controller.publishable_html_resources(resources))
#        binding.pry

        make_sitemap_yml()
        resources
      end
    end ## class SiteTree
  end ## module Aks
end ## module Middleman
################################################################

