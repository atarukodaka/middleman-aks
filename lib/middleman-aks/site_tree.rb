require 'middleman-aks/processor'
require 'rubytree'

module Middleman
  module Aks
    # == SiteTree Class Description
    #
    # This class provies a *SiteTree* class whoes instances contains a tree of the site managed by Middleman.
    #
    class SiteTree < Processor
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

      # @private
      def _dirs(resources)
        hash = {}
        resources.each do | resource |
          hash[File.dirname(resource.path)] = true
        end
        #hash.keys.reject {|k| k == "."}   # ignore "." as root dir
        hash.keys
      end
      # @params Array Sitemap::Resource
      #
      def make_tree(resources)
        # first, make a tree with directory points only
        @root = TreeNode.new('Home', controller.root)
#        binding.pry
        _dirs(resources).each do | dir |
          next if dir == "."   # skip if its root as alread exists

          node = @root
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
          dirs = File.dirname(resource.path).split("/")
          dirs.pop if dirs.size == 1  && dirs.first == "." # take it out "." as its root
          
          if File.basename(resource.path) == @app.index_file 
            # "a/b/index.html" => ['a']
            dirname = dirs.pop

            node = @root  # parent node
            dirs.each {| dir | node = node[dir] } # ['a', 'b', 'c'] => node['a']['b']['c']
            #node.content = resource
#            binding.pry
            node[dirname].content = resource
          else
            # "a/b/c.html" => ['a', 'b']

            node = @root   # parent node
            dirs.each {| dir | node = node[dir] } # ['a', 'b', 'c'] => node['a']['b']['c']
            name = File.basename(resource.path)
            new_node = TreeNode.new(name, resource)
            node << new_node
          end
        end
        return @root
      end
      def _make_tree(resources)
#        binding.pry
        @root = TreeNode.new('Home', @app.path_for("/#{@app.index_file}"))
        @app.logger.warn("root resource ('/#{@app.index_file}') doesnt exist.")

#        resources.map(&:path).each do | file |
        resources.each do |resource|
          next if resource.path =~ /\/index\.html$/ || resource.path == "index.html"
          node = @root  

          # e.g.
          #   "foo/bar.html" => ["foo"]
          #   "test.html" => ["."] => []
          dirs = File.dirname(resource.path).split("/")
          dirs.shift if dirs.first == "."

      #    binding.pry
      #    paths = [dirs, File.split(file).last].flatten
          dirs.inject ('') do |res, path|
            if node[path].nil?
              new_node = TreeNode.new(path, @app.path_for([res, path, "index.html"].join("/")))
              node << new_node
              node = new_node
            else
              node = node[path]
            end
            [res, path].join("/")
          end

          new_node = TreeNode.new(File.split(file).last, @app.path_for(resource.path))
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
        #make_tree(resources.select {|res| res.ext == ".html" && ! res.ignored?})
#        make_tree(controller.articles)
        make_tree(resources.select {|res| res.ext == ".html" && ! res.ignored? })
        return resources
#
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

