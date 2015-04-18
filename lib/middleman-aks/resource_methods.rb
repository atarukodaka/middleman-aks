module Middleman::Aks
  class ResourceMethods
    module InstanceMethods
      def digest(length = 250)
        require 'nokogiri'
        rendered = render(layout: false)
        Nokogiri::HTML(rendered).text[0..length-1]
      end
      def page_title
        (data.title || metadata[:page]['title'] || "(untitiled)").to_s
      end
      def short_title(num_charactors=30, leading_message="...")
        s = page_title
        #binding.pry
        app.logger.debug("size: #{s.size}")
        if s.size > num_charactors        
          s[0..num_charactors-1] + leading_message
        else
          s
        end
      end
      def parentage_nodes
        return [] if path == app.index_file

        require 'ostruct'
        nodes = [OpenStruct.new(name: "Home", page: app.top_page)]
        dir = File.dirname(path)
        #return [app.top_page] if dir == "."
        return nodes if dir == "."

        parts = dir.split('/')
        parts.pop if directory_index?
        
        #nodes = [OpenStruct.new(name: "Home", page: app.top_page)]
        
        parts.inject('') do |res, part|
          new_res = "#{res}/#{part}"
          parent_page = app.page_for(File.join(new_res, app.index_file)) ||
            app.page_for("#{new_res}.html")
          hash = OpenStruct.new(name: (parent_page) ? parent_page.data.title : part,
                                  page: parent_page)
          nodes << hash
          new_res
        end

        return nodes
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
