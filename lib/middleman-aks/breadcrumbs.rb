require 'middleman-aks/processor'

module Middleman
  module Aks
    class Breadcrumbs < Processor
      module Helpers
        def breadcrumbs(page)
          node = aks.site_tree.node_for(page)
          crumbs = []
          
          logger.warn "node is nil for page: #{page.path}" if node.nil?
          return 'node is nil' if node.nil?

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
################################################################
