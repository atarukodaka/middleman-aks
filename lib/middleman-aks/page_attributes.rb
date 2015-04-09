module Middleman::Aks
  module PageAttributes
    module InstanceMethodsToResource
      ################
      def is_top_page?
        url == '/'
      end
      ################
      # return title of the page
      #   1. frontmatter if specified
      #   2. "Home" if top page (path: /index.html)
      #   3. use implied title from path as follows:
      #     /foo/bar/index.html => "bar"  (directory index)
      #     /foo/bar/baz.html => "baz"
      #
      def title
        unless title = data.title || metadata[:page]['title']
          title =
            if is_top_page?
              "Home"
            elsif directory_index?
              File.dirname(path).split('/').last
            else
              File.basename(path, ".*")
            end
          add_metadata(page: {title: title})
        end
        return title
      end

      ################
      # return date of the page
      #   1. frontmatter if specified
      #   2. ctime() of the source file
      #
      def date
        if date = metadata[:page]['date']
          date = Date.parse(date) if ! date.is_a? Date
        else
          ctime = File.exists?(source_file) ? File.ctime(source_file) : Time.now
          date = ctime.to_date
        end

        add_metadata(page: {"date" => date})
        return date
      end
    end
    
    ################
    class << self
      def activate
        Middleman::Sitemap::Resource.class_eval do
          include InstanceMethodsToResource
        end
      end
    end
  end  # module PageAttributes
end
