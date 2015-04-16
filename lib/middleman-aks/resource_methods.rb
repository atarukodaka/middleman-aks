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
    end
    
    class << self
      def activate
        Middleman::Sitemap::Resource.include InstanceMethods
      end
    end
  end
end
