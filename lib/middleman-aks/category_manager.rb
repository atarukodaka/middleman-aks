require 'middleman-aks/processor'
require 'middleman-blog/uri_templates'
require 'middleman-blog/extension'

module Middleman::Aks
  class CategoryManager < Processor
    module InstanceMethodsToBlogData
      def categories
        @categories ||= articles.group_by {|p| p.category }.reject {|c, a| c.nil?}
      end
    end ## module InstanceMethodsToBlogData
    module InstanceMethodsToBlogArticle
      def category
        return self.data.category || self.metadata[:page]["category"]
      end
    end
    ################
    module Helpers
=begin
      def link_to_category(category, blog_name=nil)
      #def category_path(category, blog_name = nil)
        caption ||= h(category)
        #link_to(caption, aks.processors.category_manager.url_for(category))
        link_to(caption, "categories/#{category}.html")
        #link_to(caption, blog_controller(blog_name).category_pages.link(category))
      end
=end
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
    include Middleman::Blog::UriTemplates
    def initialize(app, controller, options = {})
      super
#      @template = controller.options.category_template
#      @uri_template = uri_template(controller.options.categorylink)
#      app.ignore @template
      
      self.class.activate
    end
=begin
    def page_for(category)
      app.sitemap.find_resource_by_path(url_for(catgory))
    end
    def url_for(category)
      apply_uri_template(@uri_template, {category: category})
    end
    def manipulate_resource_list(resources)
      newres = app.blog.categories.map do |category, articles|
        path = url_for(category)
        Middleman::Sitemap::Resource.new(app.sitemap, path).tap {|r|
          r.proxy_to(@template)
          data = {locals: {category: category, articles: articles}}
          r.add_metadata data
        }
      end
      resources + newres
    end
=end
  end ## CategoryManager
end ## module Middleman::Aks
