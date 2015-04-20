require 'middleman-aks/resource_node'

module Middleman::Aks
  class ResourceMethods
    module InstanceMethods
      def digest(length = 250)
        require 'nokogiri'
        rendered = render(layout: false)
        Nokogiri::HTML(rendered).text[0..length-1]
      end
      def name
        title = data.title || metadata[:page]['title']
        return title if title
        return "Home" if is_top_page?

        if directory_index?
          if File.basename(path) == "index.html"
            File.dir(path).split('/').last
          else
            File.basename(path, ".*")
          end
        else
          File.basename(path, ".*")
        end
      end

      def short_title(num_charactors=30, leading_message="...")
        s = data.title || metadata[:page]['title']
        #binding.pry
        app.logger.debug("size: #{s.size}")
        if s.size > num_charactors        
          s[0..num_charactors-1] + leading_message
        else
          s
        end
      end
      def is_top_page?
        path == app.index_file
      end
       
      def breadcrumbs_nodes
        nodes = [Node.new('Home', app.top_page)]

        if try(:blog_controller)
          if category
            nodes << Node.new(category, app.page_for(app.category_path(category)))
          end
        else
          dir = File.dirname(path)
          if dir != '.'
            parts = dir.split('/')
            parts.pop if directory_index?
            
            parts.inject('') do |res, part|
              new_res = "#{res}/#{part}"
              parent_page = app.page_for(File.join(new_res, app.index_file)) ||
                app.page_for("#{new_res}.html")
              nodes << Node.new(parent_page.try(:name) || part, parent_page)
              new_res
            end

          end
        end
        if ! is_top_page?
          name = data.title || File.basename(path, ".*")
          nodes << Node.new(name, self)
        end
        return nodes

      end
      ### pagination
      def prev_page
        metadata[:locals]['prev_page']
      end
      def next_page
        metadata[:locals]['next_page']
      end
      def paginated_resources
        pages = [self]
        page = self
        while page.prev_page
          pages.unshift(page.prev_page)
          page = page.prev_page
        end
        
        page = self
        while page.next_page
          pages.push(page.next_page)
          page = page.next_page
        end
        
        return pages
      end
    end  ## InstanceMethods
    
    class << self
      def activate
        Middleman::Sitemap::Resource.class_eval do
          include InstanceMethods
        end
      end
    end
  end
end
################################################################
