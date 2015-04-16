require 'middleman-aks/helpers'

module Middleman
  module Aks
    ################
    class Extension < Middleman::Extension
      helpers do
        include Middleman::Aks::Helpers
      end ## helpers

      ################
      # option settings
      #
=begin
      def initialize(klass, options_hash={}, &block)
        super
        #klass.set :aks_settings, options
      end
=end      
      ################
      # Hooks
      def after_configuration
        #app.logger.level = 0   ## yet: debug
        app.logger.debug "- extension: after_configuration"

        #require 'middleman-aks/article_attributes'
        #require 'middleman-aks/blog_article_methods'
        require 'middleman-aks/resource_methods'
        require 'middleman-aks/category_methods'

        Middleman::Aks::ResourceMethods.activate
        Middleman::Aks::CategoryMethods.activate
      end
    end
  end
end
