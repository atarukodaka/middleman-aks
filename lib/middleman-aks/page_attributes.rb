

module Middleman
  module Aks
    module PageAttributes
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
          return "Home" if self == app.aks.top_page
          return (directory_index?) ? File.dirname(path).split("/").last : File.basename(path).sub(/\.html$/, '')
        end
        def ctime
          File.exists?(source_file) ? File.ctime(source_file) : Time.now
        end
        def mtime
#          File.exists?(source_file) ? File.mtime(source_file) : Time.now
          Time.now
        end
        def date
          @date ||= 
            if data.date
              if data.date.is_a? Date
                data.date 
              else
                Date.parse(data.date)
              end
            else
              #Date.new(2000,1,1)
              ctime.to_date
            end
#          (data.date) ? (data.date.is_a? Date) ? data.date :  Date.parse(data.date) : ctime.to_date
        end
        
        # relevant node on the site tree
        def node
          app.aks.site_tree.node_for(self)
        end
      end
    end # module PageAttributes
  end
end
################################################################
