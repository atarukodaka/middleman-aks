module Middleman
  module Aks
    module Breadcrumbs
      module Helpers
        def breadcrumbs(page)
          lists = []

          top_page = sitemap.find_resource_by_path("/index.html")
          if page == top_page
            lists << content_tag(:li, "Home", :class => 'active')
          else
            lists << [content_tag(:li, link_to("Home", top_page))]

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
      end ## module Helpers
    end
  end
end
