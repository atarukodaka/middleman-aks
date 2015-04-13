

module Middleman::Aks
  module LinktoHelpers
    def link_to_page(page, caption = nil)
      if ! page.is_a?(Middleman::Sitemap::Resource)
        page = sitemap.find_resource_by_path(page) || raise("no such resource: #{page}") # yet
      end
      #link_to(h(page.data.title) || "(untitled)", page)
      caption ||= page.data.title
      link_to(h(caption) || "(untitled)", page)
    end
    def link_to_page_formatted(page, format=nil)
      format ||= "%{page_link}...<small>[%{category}] at %{date}</small>"

      hash = {
        page_link: link_to_page(page),
        page_title: h(page.data.title),
        category: link_to(page.category) || "-",
        date: page.date.strftime("%d %b %Y")
      }
      format % hash
    end
  end

  ################
  module SelectPageHelpers
    def top_page
      sitemap.find_resource_by_path("/" + index_file()) 
    end

    def select_html_pages
      sitemap.resources.select {|p| p.ext == ".html"}   # .each {|page|
    end
    def select_resources_by(key, value)
      sitemap.resources.select {|p| p.send(key.to_sym) == value}
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
    def page_info(page)
      ["", 
       (page.category.nil?) ? "-" : link_to_category(page.category),
       page.date.strftime("%d %b %Y %Z"),
       link_to("permlink", page)
      ].join(" | ")
    end

    def breadcrumbs(page)
      lists = []

      if page == top_page
        lists << content_tag(:li, h(page.data.title), :class => 'active')
      elsif page.try(:blog_controller)
        lists << [content_tag(:li, link_to_page(top_page)),
                  content_tag(:li, link_to_category(page.category)),
                  content_tag(:li, h(page.title), :class => 'active')
                 ]
      else
        lists << [content_tag(:li, link_to_page(top_page))]

        parts = page.path.split("/")
        parts.pop     ## take out filename on the last of the parts array
        parts.pop if page.path =~ /\/#{index_file()}/  ## take it out if .../index.html

        parts_tmp = parts.dup

        lists << parts.reverse.map {|d| 
          p = nil
          [File.join(parts_tmp.join("/"), index_file()), 
           parts_tmp.join("/") + ".html"].each do |path|
            p = sitemap.find_resource_by_path(path)
            break if p
          end
          parts_tmp.pop
          content_tag(:li, (p) ? link_to(d, p) : d)
        }.reverse
        lists << content_tag(:li, h(page.data.title || yield_content(:title)), :class => "active")
      end
 
      content_tag(:nav, :class=>"crumbs") do
        content_tag(:ol, lists.flatten.join("").html_safe, :class=>"breadcrumb")
      end
    end


    # pagerhelper
    def short_title(article)  ## yet:: to BlogArticle ??
      num_charactors = 30

      if article.nil?
        ""
      else
        s = h(article.data.title)
        if s.size > num_charactors        
          s[0..num_charactors] + "..."
        else
          s[0..-1]
        end
      end
    end

    def article_pager(direction, nav_article)
      title = (nav_article.nil?) ? "" : h(nav_article.data.title)
      nav_str_w_arr = 
        case direction
        when :previous
          "<span>&larr;</span>" + short_title(nav_article)
        when :next
          short_title(nav_article) + "<span>&rarr;</span>"
        else
          raise "unknown direction: #{direction}"
        end
      css_class = direction.to_s
      css_class += " disabled" if nav_article.nil?

      content_tag(:li, :class => css_class) do 
        link_to(nav_str_w_arr, nav_article, {"data-toggle" => "tooltip", "title" => title})
      end
    end

    def share_sns(page)
      [share_twitter(data.config.site_info.twitter), share_haten_bookmark(page)].join("")
    end

    def copyright
      years = blog.articles.group_by {|a| a.date.year}.map {|year, articles| year}
      start_year = years[-1]
      end_year = years[0]

      years_str = (start_year == end_year) ? start_year.to_s : "%d-%d" % [start_year, end_year]
      "&copy; %s by %s (%s)" % [years_str, h(data.config.site_info.author), h(data.config.site_info.email)]
    end
  end
  
  ################################################################
  module Helpers
    include ERB::Util
    include LinktoHelpers
    include SelectPageHelpers    
    include ArticleContentHelpers
  end ## module Helpers
end ## module Middleman::Aks
