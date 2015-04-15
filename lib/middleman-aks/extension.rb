#require 'middleman-aks/controller'
require 'middleman-aks/helpers'

require 'middleman-aks/article_attributes'
require 'middleman-aks/category_attributes'


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

        Middleman::Aks::ArticleAttributes.activate
        Middleman::Aks::CategoryAttributes.activate
      end
    end
  end
end
