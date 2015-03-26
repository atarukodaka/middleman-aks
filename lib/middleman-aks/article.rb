module Middleman
  module Aks
    class Article
      module InstanceMethodsToResource
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
      end

      def initialize(app, ext, options = {})
        @app = app
        @ext = ext
      end
    end ## class Article
  end
end
