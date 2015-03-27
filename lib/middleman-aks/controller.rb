
module Middleman
  module Aks
    class Controller
      def initialize(app, ext)
        @app = app
        @ext = ext
      end

      def after_configuration
#        binding.pry
      end
    end
  end
end
