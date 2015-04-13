#require 'middleman-aks/controller'
require 'middleman-aks/helpers'

require 'middleman-aks/category_manager'

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

=begin
        def aks
          @aks
        end
        def aks=(ext)
          @aks = ext
        end
=end
      end ## helpers

      ################
      # option settings
      #
      option :category_template, "proxy_templates/category_template.html"
      option :categorylink, "categories/{category}.html"
      attr_reader :processors
      def initialize(klass, options_hash={}, &block)
        super
        #klass.set :aks_settings, options

        Middleman::Blog::BlogArticle.class_eval do
          include Middleman::Aks::SummaryText::InstanceMethodsToBlogArticle
        end
      end
      
      ################
      # Hooks
      def after_configuration
        #app.logger.level = 0   ## yet: debug
        app.logger.debug "- extension: after_configuration"
#        app.aks = self

        if prefix = app.blog_controller.options.prefix
          options.categorylink = File.join(prefix, options.categorylink)
        end
        
        require 'ostruct'
        @processors =
          OpenStruct.new(category_manager: CategoryManager.new(app, self))

        #app.aks = Middleman::Aks::Controller.new(app, self)
      end
    end
  end
end
