require 'middleman-aks/controller'
require 'middleman-aks/helpers'

module Middleman
  module Aks
    module SummaryText
      module InstanceMethodsToBlogArticle
        def summary_text(length = 250, leading_message = "...read more")
          require 'nokogiri'
          rendered = render(layout: false)
          Nokogiri::HTML(rendered).text[0..length-1] + app.link_to(leading_message, self)
        end
      end
    end
    ################
    class Extension < Middleman::Extension
      helpers do
        include Middleman::Aks::Helpers
        # general utils
        def page_for(path)
          sitemap.find_resource_by_path(path)
        end
        alias_method :resource_for, :page_for

=begin
        def link_to_page(page)
          link_to(h(page.title), page)
        end
=end
        def top_page
          sitemap.find_resource_by_path("/#{index_file}")
        end

        # controller accessors
        def aks_controller
          @_aks_controller
        end
        
        def aks_controller=(controller)
          @_aks_controller = controller
        end
        alias_method :aks, :aks_controller
        alias_method :aks=, :aks_controller=
      end ## helpers

      ################
      # option settings
      #
      option :category_template, "proxy_templates/category_template.html"
      option :category_uri_template, "categories/{category}.html"
      
=begin
      option :index_template, "/templates/index_template.html"
      option :archives_template_year, "/templates/archives_template_year.html"
      option :archives_template_month, "/templates/archives_template_month.html"
      option :archives_path_year, "/archives/%{year}/index.html"
      option :archives_path_month, "/archives/%{year}/%{month}.html"

      option :numbering_headings, true, "show numbering for headers"
=end
      
      def initialize(klass, options_hash={}, &block)
        super
        klass.set :aks_settings, options

        Middleman::Blog::BlogArticle.class_eval do
          include Middleman::Aks::SummaryText::InstanceMethodsToBlogArticle
        end

        
      end
      
      ################
      # Hooks
      def after_configuration
        #app.logger.level = 0   ## yet: debug
        app.logger.debug "- extension: after_configuration"

        app.aks = Middleman::Aks::Controller.new(app, self)
      end
    end
  end
end
