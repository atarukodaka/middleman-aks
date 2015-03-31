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
              crumbs << content_tag(:li, (nd.resource) ? link_to(h(nd.name), nd.resource) : h(nd.name))
            end
            crumbs << content_tag(:li, h(page.data.title || node.name), :class=>'active')
          end
          
          content_tag(:nav, :class=>'crumbs') do
            content_tag(:ol, crumbs.join.html_safe, :class=>'breadcrumb')
          end
        end
      end ## module Helpers
    end
  end
end
