require 'middleman-aks/processor'

module Middleman::Aks
  class CategoryManager < Processor
    module InstanceMethodsToBlogData
      def categories
        articles.group_by {|p| p.category }
      end
    end ## module InstanceMethodsToBlogData
    module InstanceMethodsToBlogArticle
      def category
        return self.data.category || self.metadata[:page]["category"]

      end
      def summary_text(length = 250, leading_message = "...read more")
        rendered = render(layout: false)
        Nokogiri::HTML(rendered).text[0..length-1] + app.link_to(leading_message, self)
      end

    end
    module Helpers
      def category_summary_page_path(category)
        #blog_category_summary_settings.outputpath_template % {category: h(category)}
        "categories/%{category}.html" % {category: h(category)}
      end
      def link_to_category_summary_page(category)
        link_to(h(category), category_summary_page(category))
      end
      def category_summary_page(category)
        sitemap.find_resource_by_path(category_summary_page_path(category))
      end
    end
    ################
    class << self
      def activate
        Middleman::Blog::BlogArticle.class_eval do
          include InstanceMethodsToBlogArticle
        end
        Middleman::Blog::BlogData.class_eval do
          include InstanceMethodsToBlogData
        end
      end
    end
    
    def initialize(app, controller, options = {})
      super
      @category_template = "proxy_templates/category_summary_template.html"
      app.ignore @category_template

      self.class.activate
    end
    def after_configuraion
      template = @category_template
      app.ready do
# =>         category_template = "proxy_templates/category_summary_template.html"

        blog.articles.group_by {|a| a.category}.each do |category, articles|
          next if category.nil?
          proxy(category_summary_page_path(category), @template,
                :locals => { :category => category, :articles => articles, :ignore => true })
        end
      end
    end
  end ## CategoryManager
end ## module Middleman::Aks
