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
        title = page.data.title || page.metadata[:page]['title']
        return title if title

        title =
          if page.app.aks.is_top_page?(page)
            "Home"
          elsif page.directory_index?
            File.dirname(page.path).split('/').last
          else
            File.basename(page.path, ".*")
          end
        page.add_metadata(page: {title: title})
        return title
      end
      ################
      # return date of the page
      #   1. frontmatter if specified
      #   2. ctime() of the source file
      #
      def page_date(page)
        #date = page.metadata[:page]['date'] ||=
        if date = page.metadata[:page]['date']
          if date.is_a? Date
            return date
          else
            date = Date.parse(date)
          end
        else
          date_str =
            begin
              ctime = File.exists?(page.source_file) ? File.ctime(page.source_file) : Time.now
              page.app.logger.debug "getting ctime of #{page.path}"
              ctime.strftime("%Y-%m-%d")
            end
          date = Date.parse(date_str)
        end
#        binding.pry
        page.add_metadata(page: {"date" => date})
        return date
      end
    end  # module Utils
  end
end








