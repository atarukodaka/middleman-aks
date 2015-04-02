

module Middleman
  module Aks
    module InstanceMethodsToResource
      # attributes
      def title
        data.title || metadata[:page]["title"] || ((dir, fname = File.split(path); fname == app.index_file) ? File.split(path).first.split("/")[-1] : fname.sub(/\.html$/, "")) || "[untitled...]"
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

      # node
      def node
        
      end
      
      # split dirname of paths
      #
      # @return Array path: "/foo/bar/baz.html" => ['foo', 'bar']
      def dirs
        array = File.dirname(self.path).split("/")
        array.pop if self.directory_index?
        array
      end
    end
  end
end

Middleman::Sitemap::Resource.include Middleman::Aks::InstanceMethodsToResource
