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
          }
          hash[:children] =  children.map(&:to_hash) if has_children?
          hash
        end
      end

      ################
      # @!attribute [r] root
      # 
      attr_reader :root

      ################
      # make_tree
      #
      # @params Array of Sitemap::Resource
      #
      # @return Middleman::SiteTree::TreeNode root node
      def make_tree(resources)
        # first, make a tree with directory points only
        @root = TreeNode.new('Home', controller.top_page)  # set root node at first

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
          next if resource == controller.top_page
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
        options.reverse_merge!(depth: 0, num: 0)
        depth = options[:depth]
        num = options[:num]
        depth, num = [:depth, :num].map {|key| options[key]}

        collapse = 'collapse' + ((depth <=1 ) ? ' in' : '')
        
        return if ! [options[:exclude_dirs]].flatten.select {|re| node.resource.try(:path) =~ re }.empty?

        # , :class=>(node.try(:resource) == @app.current_resource) ? 'active' : '') do
        target_id = "menu_#{depth}_#{num}"
        
        app.content_tag(:li) do
          pointer = 
            if node.has_children?
              app.content_tag(:a, "[+] ", 'data-toggle'=>'collapse', 'data-target'=>"##{target_id}", :style=>'cursor: pointer')
            end
          caption = 
            if node.resource && node.resource == @app.current_resource
              app.content_tag(:span, h(node.resource.title), :class=>'active')
            else
              app.link_to(h(node.resource.title), node.resource)
            end
          children_rendered = app.content_tag(:ul, :class=>collapse, :id=>target_id) do 
            node.children.sort {|a, b|
              a.children.try(:size) <=> b.children.try(:size)
            }.map do |child|
              opts = options.dup.tap {|o| 
                o[:depth] = o[:depth].to_i + 1
                o[:num] = o[:num].to_i + 1
              }
              render(child, opts).tap { num = num + 1 }
            end.join.html_safe
          end
          [pointer, caption, children_rendered].join.html_safe
                      
=begin
          [
           (node.has_children?) ? @app.content_tag(:a, "[+] ", 'data-toggle'=>'collapse', 'data-target'=>"##{target_id}", :style=>'cursor: pointer') : '',
           (node.resource && node.resource != @app.current_resource) ? @app.link_to(h(node.resource.title), node.resource) : @app.content_tag(:span, h(node.resource.title), :class=>'active'),
           app.content_tag(:ul, :class=>collapse, :id=>target_id) do 
             node.children.sort {|a, b|
               a.children.try(:size) <=> b.children.try(:size)
             }.map do |child|
               render(child, exclude_dirs: options[:exclude_dirs], depth: depth+1, num: num).tap { num = num + 1 }
             end.join.html_safe
           end
          ].join.html_safe
=end
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
        return @root if resource == controller.top_page
        
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
        if resource == controller.top_page
          "Home"
        elsif resource.directory_index?
          File.dirname(resource.path).split("/").last
        else
          File.basename(resource.path)
        end
      end
      ################
      # Manipulate resource list
      #
      def manipulate_resource_list(resources)   
        make_tree(controller.pages)
        resources
      end
    end ## class SiteTree
  end ## module Aks
end ## module Middleman
################################################################

