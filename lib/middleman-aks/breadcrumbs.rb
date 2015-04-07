require 'middleman-aks/processor'

module Middleman
  module Aks
    class Breadcrumbs < Processor
      module Helpers
        def _crumbs(page)
          node = aks.site_tree.node_for(page)
          if node.nil?
            logger.debug("node is nil for page: #{page.path}")
            return []
          end


          if page == aks.top_page
            ["Home"]
          else
            node.parentage.map {|nd|
              (nd.resource) ? link_to(h(nd.name), nd.resource) : h(nd.name)
            }.reverse
          end
        end
        def breadcrumbs(page = nil, options = {})
          default_options = {
            parentage_only: false,
            bootstrap_style: true,
            delimiter: ' / '
          }

          page ||= current_page
          options.reverse_merge! default_options

          if options[:bootstrap_style]
            crumbs = _crumbs(page).map {|item| content_tag(:li, item)}
            crumbs << content_tag(:li, h(page.data.title), :class=>'active') if page != aks.top_page
            content_tag(:ol, crumbs.join.html_safe, :class=>'breadcrumb')
          else
#            binding.pry
            ar = _crumbs(page)
            ar.join(options[:delimiter])
          end
        end
      end ## module Helpers
    end
  end
end
################################################################
