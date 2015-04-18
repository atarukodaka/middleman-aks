

module Middleman::Aks
  module ResourceHelpers
    # general utils
    def page_for(path)
      sitemap.find_resource_by_path(path)
    end
    alias_method :resource_for, :page_for
    
  end
  module LinktoHelpers
    def link_to_page(page, caption = nil)
      link_to(caption || h(page.data.title) || "(untitled)", page)
    end
    def link_to_category(category, caption=nil)
      link_to(caption || h(category), category_path(category))
    end
  end

  ################
  module SelectPageHelpers
    def top_page
      sitemap.find_resource_by_path("/" + index_file()) 
    end
  end
  ################
  module ArticleContentHelpers
    def toggle_collapse(id, caption="Open/Close", &block)
      [content_tag(:button, caption,
                   :type => 'button', :class=>'btn btn-default collapsed btn-sm',
                   "data-toggle" => 'collapse', "data-target" => "##{id}"),
       content_tag(:div, :id => "#{id}", :class => "collapse") do
         yield
       end].join.html_safe
    end
=begin
    def page_info(page)
      ["", 
       (page.category.nil?) ? nil : link_to_category(page.category),
       page.date.strftime("%d %b %Y %Z"),
       link_to("permlink", page)
      ].reject(&:nil?).join(" | ")
    end
=end

    def breadcrumbs(page)
      lists = []
      # caption:, path:, class
      
      if page == top_page
        lists << {name: 'Home', page: nil, :class => 'active'}
      else
        if page.try(:blog_controller)
          lists << {name: 'Home', page: top_page}
          if page.category
            lists << {name: page.category, page: page_for(category_path(page.category))}
          end
        else
          page.parentage_nodes.each do |node|
            lists << {name: node.name, page: node.page}
          end
        end
        lists << {name: page.data.title, page: nil, :class => 'active'}
      end
      
      content_tag(:nav, :class=>"crumbs") do
        content_tag(:ol, :class=>"breadcrumb") do
          lists.map do |hash|
            content_tag(:li, :class=>hash[:class]) do
              (hash[:page]) ? link_to(h(hash[:name]), hash[:page]) : h(hash[:name])
            end
          end.join('').html_safe
        end
      end
    end

    def article_navigator(direction, nav_article)
      # nav_article can be nil
      title = nav_article.try(:title) || ""

      short_title = nav_article.try(:short_title) || ""
      
      nav_str_w_arr = 
        case direction
        when :previous
          "<span>&larr;</span>#{short_title}"
        when :next
          "#{short_title}<span>&rarr;</span>"
        end
      css_class = [direction.to_s]
      css_class << "disabled" if nav_article.nil?

      content_tag(:li, :class => css_class.join(" ")) do 
        link_to(nav_str_w_arr, nav_article, {"data-toggle" => "tooltip", "title" => title})
      end
    end

    def copyright
      years = blog.articles.group_by {|a| a.date.year}.keys
      return "&copy; " + [years.min, years.max].uniq.join("-")
    end
  end

  module YoutubeHelpers
    ## youtube
    def youtube(id, width=560, height=nil, opt = {})
      height ||= (width.to_f * 0.5625).ceil
      opt_str = opt.map {|key, value| h(key.to_s) + "=" + h(value.to_s)}.join("&")
      templ = <<EOS
<iframe width="%{width}" height="%{height}" src="http://www.youtube.com/embed/%{id}?%{opt_str}"></iframe>
EOS
      templ % {height: height.to_i, width: width.to_i, id: h(id), opt_str: opt_str}
    end
  end
  
  ################################################################
  module Helpers
    include ERB::Util
    include ResourceHelpers
    include LinktoHelpers
    include SelectPageHelpers    
    include ArticleContentHelpers
    include YoutubeHelpers
  end ## module Helpers
end ## module Middleman::Aks
