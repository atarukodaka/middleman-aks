

module Middleman
  module Aks
    module InstanceMethodsToResource
      # attributes
      def title
        # return metadata if specified
        t = data.title || metadata[:page]["title"]
        return t if t

        # /index.html => "Home"
        # /foo/index.html => "foo"  (as its directory index)
        # /foo/bar.html => "bar"
        #
        return "Home" if self == app.controller.root
        return (directory_index?) ? File.dirname(path).split("/").last : File.basename(path).sub(/\.html$/, '')
      end
      def ctime
        File.exists?(source_file) ? File.ctime(source_file) : Time.now
      end
      def mtime
        File.exists?(source_file) ? File.mtime(source_file) : Time.now
      end
      def date
        (data.date) ? (data.date.is_a? Date) ? data.date :  Date.parse(data.date) : ctime.to_date
      end

      # relevant node on the site tree
      def node
        app.controller.site_tree.node_for(self)
      end
=begin
      
      # split dirname of paths
      #
      # @return Array path: "/foo/bar/baz.html" => ['foo', 'bar']
      def dirs
        array = File.dirname(self.path).split("/")
        array.pop if self.directory_index?
        array
      end
=end
    end
  end
end

#Middleman::Sitemap::Resource.include Middleman::Aks::InstanceMethodsToResource
