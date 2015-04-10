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
      ################
      # node class
      class TreeNode < Tree::TreeNode
        alias_method :resource, :content

        def path
          return resource.path if resource
#          parentage[0..-1].map {|p| p.name}.join("/")
          return "" if parentage.nil?  # for the case /index.html doest not exist
          parentage.map {|p| p.name}.join("/")
        end

        def to_hash
          hash = {
            name: name,
            title: (resource.nil?) ? name : resource.title,
            path: resource.try(:path)
          }
          hash[:children] =  children.map(&:to_hash) if has_children?
          hash
        end
      end
      ################
      # helpers
      module Helpers
        def breadcrumbs(page = nil, options = {})
          page ||= current_page
          
          default_options = {
            bootstrap_style: true,
            delimiter: ' / '
          }
          options.reverse_merge! default_options

          node = aks.site_tree.node_for(page)
          parentage =
            if page.is_top_page?
              ["Home"]
            else
              node.parentage.map {|nd|
              #(nd.resource) ? link_to(h(nd.name), nd.resource) : h(nd.name)
              (nd.resource) ? link_to_page(nd.resource) : h(nd.name)
            }.reverse
            end
          
          if options[:bootstrap_style]
            crumbs = parentage.map {|item| content_tag(:li, item)}
            crumbs << content_tag(:li, h(page.title), :class=>'active') if ! page.is_top_page?
            content_tag(:ol, crumbs.join.html_safe, :class=>'breadcrumb')
          else
            parentage.shift if ! parentage.nil?
            parentage.join(options[:delimiter])
          end
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
        @root = TreeNode.new('Home', app.top_page)  # set root node at first

        # listing up all directory and register into the tree
#        binding.pry
        controller.directory_list(resources).each do | dir |
          #next if dir == "."   # skip if its root as alread registered before this loop

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
          next if resource.is_top_page?
#          next if ! [@ignore_dirs].flatten.select {|re| resource.path =~ re }.empty?

          dirs = File.dirname(resource.path).split("/")
          dirs.pop if dirs.size == 1  && dirs.first == "." # take it out "." as its root
          
#          if File.basename(resource.path) == @app.index_file 
          if resource.directory_index?
            # "a/b/index.html" => ['a']
            dirname = dirs.pop
            app.logger.debug.warn "dirname is nil for resource: #{resource.path}" if dirname.nil?
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
      # validate
      def validate
        app.logger.debug "- validate all resources registered into the tree"
        controller.pages.each do | resource |
          node = node_for(resource)
          if node.nil?
            app.logger.warn "NG: #{resource.path} does NOT have node"
          else
            app.logger.debug "ok: #{resource.path}"
          end
        end
      end
      
      ################
      # Render the tree.
      #
      def render(node = nil, options = {})
        node ||= @root
        options.reverse_merge!(depth: 0, num: 0)
        depth, num, prefix = [:depth, :num, :prefix].map {|key| options[key]}
     
        return if ! [options[:exclude_dirs]].flatten.select {|re| node.resource.try(:path) =~ re }.empty?

        app.content_tag(:li) do
          target_id = [prefix, "menu", depth, num].join("_")
          pointer = 
            if node.has_children?
              app.content_tag(:a, "[+] ", 'data-toggle'=>'collapse', 'data-target'=>"##{target_id}", :style=>'cursor: pointer')
            end
          caption = 
            if node.resource.nil?
              node.name
            else
              if node.resource == app.current_resource
                app.content_tag(:span, h(node.resource.title), :class=>'active')
              else
                app.link_to(h(node.resource.title || node.name), node.resource)
              end
            end

          flag = 
            if options[:open_all]
              true
            else
              curr_path = File.dirname(app.current_resource.path).sub(/^\./, '') + "/"
              node_path = File.dirname(node.path).sub(/^\./, '') + "/"
              curr_path =~ Regexp.new(node_path)
            end

          collapse_in = (!flag.nil?) ? 'in' : ''
          
#          logger.debug "#{flag}: #{curr_path} =~ #{node_path}"
          children_rendered = app.content_tag(:ul, :class=>"collapse #{collapse_in}", :id=>target_id) do 
            node.children.sort {|a, b|
              a.children.try(:size) <=> b.children.try(:size)
            }.map do |child|
              opts = options.dup.tap {|o| 
                o[:depth] = o[:depth].to_i + 1
                o[:num] = num
              }
              render(child, opts).tap { num = num + 1 }
            end.join.html_safe
          end
          [pointer, caption, children_rendered].join.html_safe
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
        return @root if resource.is_top_page?

        paths = resource.path.split("/")
        paths.pop if resource.directory_index? # File.basename(resource.path) == @app.index_file

        node = @root
        paths.each do | path |
          node = node[path]
        end
        return node
      end
      ################
      def ready
        make_tree(controller.pages)
        validate()
      end
    end ## class SiteTree
  end ## module Aks
end ## module Middleman
################################################################

