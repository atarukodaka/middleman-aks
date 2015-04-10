require 'middleman-aks/processor'

module Middleman::Aks
  class TagManager < Processor
    module Helpers
      def link_to_tag(tag, caption=nil)
        caption ||= tag
        link_to(h(caption), aks.tag_manager.url_for(tag))
      end
    end
    attr_reader :tags
    def initialize(app, controller, options = {})
      super

      @tags = Hash.new {|hash, key| hash[key] = []}
      
      @template = "templates/tag.html"  ## yet: options
      @path_template = "tags/%{tag}.html"

      app.ignore @template
    end
    
    def url_for(tag)
      return @path_template % {tag: tag}
    end

    def manipulate_resource_list(resources)
      
      # collect tags on the resources
      resources.each do |r|
        r.tags.each do |tag|
          @tags[tag] << r
        end
      end

      # sort by newest
      @tags.each do |tag, pages|
        @tags[tag] = pages.sort_by(&:date).reverse
      end

      # generate proxy pages
      newres = []
      if ! app.resource_for(@template).nil?
        tags.map do |tag, pages|
          data = {locals: {tag: tag, pages: pages}}
          newres << controller.create_proxy_page(url_for(tag), @template, data)
        end
      end
      return resources + newres
    end
  end ## class Tags
end
################################################################
