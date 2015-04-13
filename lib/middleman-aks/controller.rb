require 'middleman-aks/category_manager'

module Middleman
  module Aks
    # == Controller Class Description
    #
    class Controller
      include ERB::Util
      
      attr_reader :app, :ext, :processors
      delegate :options, to: :ext
      
      def initialize(app, ext)
        @app = app
        @ext = ext

        ## set processors
        require 'ostruct'
        @processors =
          OpenStruct.new(category_manager: CategoryManager.new(app, self))
      end

      ################
      # pages, directory utils
      #
    end  ## class Controller
  end
end
################################################################
