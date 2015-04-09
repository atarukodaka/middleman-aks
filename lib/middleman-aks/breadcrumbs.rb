require 'middleman-aks/processor'

module Middleman
  module Aks
    class Breadcrumbs < Processor
      module Helpers
        def breadcrumbs(page = nil, options = {})
          page ||= current_page
          
          default_options = {
            parentage_only: false,
            bootstrap_style: true,
            delimiter: ' / '
          }
          options.reverse_merge! default_options

          node = aks.site_tree.node_for(page)
          parentage =
            if page.is_top_page?
              ["Home"]
            else
              node.parentage.map {|nd|
              (nd.resource) ? link_to(h(nd.name), nd.resource) : h(nd.name)
            }.reverse
            end
          
          if options[:bootstrap_style]
            crumbs = parentage.map {|item| content_tag(:li, item)}
            crumbs << content_tag(:li, h(page.title), :class=>'active') if ! page.is_top_page?
            content_tag(:ol, crumbs.join.html_safe, :class=>'breadcrumb')
          else
#            binding.pry
            parentage.join(options[:delimiter])
          end
        end
      end ## module Helpers
    end
  end
end
################################################################
