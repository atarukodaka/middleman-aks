module Middleman
  module Aks
    #
    # these module functinos should  be able to be used as either helper or
    # included functions.
    #
    module Utils
      ################
      # return title of the page
      #   1. frontmatter if specified
      #   2. "Home" if top page (path: /index.html)
      #   3. use implied title from path as follows:
      #     /foo/bar/index.html => "bar"  (directory index)
      #     /foo/bar/baz.html => "baz"
      #
      def page_title(page)
        page.data.title || page.metadata[:page]['title'] ||=
          if page.directory_index?
            ((dir = File.dirname(page.path)) == ".") ? "Home" : dir.split('/').last
          else
            File.basename(page.path, ".*")
          end
      end
      ################
      # return date of the page
      #   1. frontmatter if specified
      #   2. ctime() of the source file
      #
      def page_date(page)
        date = page.metadata[:page]['date'] ||= 
          begin
            ctime = File.exists?(page.source_file) ? File.ctime(page.source_file) : Time.now
            ctime.strftime("%Y-%m-%d")
          end
        (date.is_a? Date) ? date : Date.parse(date)
      end
    end  # module Utils
  end
end








