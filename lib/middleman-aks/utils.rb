module Middleman
  module Aks
    module Utils
      ################
      # return title of the page
      # /index.html => "Home"
      # /foo/index.html => "foo"  (as its directory index)
      # /foo/bar.html => "bar"
      #
      def page_title(page)
        page.data.title || page.metadata[:page]['title'] ||=
          if page.directory_index?
            ((dir = File.dirname(page.path)) == ".") ? "Home" : dir.split('/').last
          else
            File.basename(page.path, ".*")
          end
      end
      def page_date(page)
        date = page.metadata[:page]['date'] ||= 
          begin
            ctime = File.exists?(page.source_file) ? File.ctime(page.source_file) : Time.now
            ctime.strftime("%Y-%m-%d")
          end
        (date.is_a? Date) ? date : Date.parse(date)
      end
      ################
=begin
      def parentage_paths(page)
        if page == page.app.aks.top_page
          return [{name: "Home", path: "/index.html", resource: page}]
        end
        
        dir, basename = File.split(page.path)
        parts = dir.sub(/^\//, '').split("/")  
        parts.pop if parts.first == "."

        if basename == "index.html"  # directory index?
          basename = parts.pop
        else
          basename.sub!(File.extname(basename), '')
        end
        
        ar = []
        parts.inject("") do |result, part|
          new_result = "#{result}/#{part}"
          path = "#{new_result}/#{page.app.index_file}"
          hash = {
            name: part,
            path: path,
            resource: page.app.sitemap.find_resource_by_path(path)
          }
          ar << hash
          new_result
        end
        ar << {name: basename, path: path, resource: page}
      end
=end
    end  # module Utils
  end
end








