module Middleman
  module Aks
    module Breadcrumbs
      module Helpers
        # @params page Middleman::Sitemap::Resouce
        #
        # @return String HTML for breadcrumps of the page
        def breadcrumbs(page)
#          binding.pry
          node = controller.site_tree.node_for(page)
          crumbs = []
          
          if node.parent.nil?  # root
            crumbs << content_tag(:li, h(node.name), :class=>'active')
          else
            node.parentage.reverse.each do |nd|
              crumbs << content_tag(:li, link_to(h(nd.name), nd.resource))
            end
            crumbs << content_tag(:li, h(page.data.title || node.name), :class=>'active')
          end
          
          content_tag(:nav, :class=>'crumbs') do
            content_tag(:ol, crumbs.join.html_safe, :class=>'breadcrumb')
          end
        end

        def _breadcrumbs(page)
#          return ""
#          binding.pry
          crumbs = []
          if page == controller.root
            crumbs << content_tag(:li, 'Home', :class => 'active')
          else
            parent = page.parent
#            while parent != controller.root
            while parent
              crumbs << content_tag(:li, link_to(File.dirname(parent.path).split("/").last, parent))
              parent = parent.parent
            end
            crumbs << content_tag(:li, link_to('Home', controller.root))
          end
          if crumbs.last == controller.root
            crumbs.pop 
          else
            @app.warn "orphen page: #{page.path}" 
            crumbs << content_tag(:li, "...")
          end
          content_tag(:nav, :class=>"crumbs") do
            content_tag(:ol, crumbs.reverse.join.html_safe, :class=>"breadcrumb")
          end

=begin          
          page.parentage.reverse.each do | parent |
            next if parent.parent.nil?  # skip if root
            crumbs << content_tag(:li, link_to(File.dirname(parent.path).split("/").last, parent))
          end
          #lists = []


          top_page = controller.root # sitemap.find_resource_by_path("/index.html")
          top_capition = "Home"

          if page == top_page
            lists << content_tag(:li, top_caption, :class => 'active')
          else
            lists << [content_tag(:li, link_to(top_caption, top_page))]

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
=end
        end
      end ## module Helpers
    end
  end
end
