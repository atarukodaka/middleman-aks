#require 'middleman-aks/controller'
require 'middleman-aks/helpers'

require 'middleman-aks/category_attributes'


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
      end ## helpers

      ################
      # option settings
      #
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

        Middleman::Aks::CategoryAttributes.activate
      end
    end
  end
end
