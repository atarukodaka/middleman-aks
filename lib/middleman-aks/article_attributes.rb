module Middleman::Aks
  class ArticleAttributes
    module InstanceMethods
      include ERB::Util
      def summary_text(length = 250, leading_message = "...read more")
        require 'nokogiri'
        rendered = render(layout: false)
        Nokogiri::HTML(rendered).text[0..length-1] + app.link_to(leading_message, self)
      end
      def short_title(num_charactors=30, leading_message="...")
        s = h(title)
        if s.size > num_charactors        
          s[0..num_charactors-1] + leading_message
        else
          s[0..-1]
        end
      end
    end

    class << self
      def activate
        Middleman::Blog::BlogArticle.class_eval do
          include InstanceMethods
        end
      end
    end
  end
end
