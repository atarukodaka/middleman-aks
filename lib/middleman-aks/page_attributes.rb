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
      ################
      def tags
#        binding.pry
        #tgs = data['tags'] || data['tag']
        logger.debug path
#        binding.pry if path == "archives/2015/index.html"
        logger.debug data

          
        tgs = data.tags || data.tag

        (tgs.is_a? String) ? tgs.split(/,/).map(&:strip) : Array(tgs).map(&:to_s)
      end
      ################
      def summary_text(length = 250, leading_message = "...read more")
        rendered = render(layout: false)
        Nokogiri::HTML(rendered).text[0..length-1] + app.link_to(leading_message, self)
#        require 'middleman-aks/truncate_html'
#        rendered = render(layout: false)
#        truncated_text = Nokogiri::HTML(TruncateHTML.truncate_html(rendered, length)).text
#        truncated_text + app.link_to(leading_message, self)
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
