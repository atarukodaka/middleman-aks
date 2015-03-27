
module Middleman
  module Aks
    class Controller
      def initialize(app, ext)
        @app = app
        @ext = ext
        @processors = {}
      end

      def articles
        @app.logger.warn "run() needs to be called before using 'articles()'" if @processors.empty?
        @processors[:article_container].articles
      end
      
      def run
        @processors = {
          article_container: Middleman::Aks::ArticleContainer.new(@app, self),
          archives: Middleman::Aks::Archives.new(@app, self),
          index_creator: Middleman::Aks::IndexCreator.new(@app, self)
        }
        @processors.each do |name, processor|
          @app.sitemap.register_resource_list_manipulator(name, processor)
        end

=begin
        @article_container = Middleman::Aks::ArticleContainer.new(@app, self)
        @archives = Middleman::Aks::Archives.new(@app, self)
        @index_creator = Middleman::Aks::IndexCreator.new(@app, self, index_template: options.index_template)

        
        @app.sitemap.register_resource_list_manipulator(:article_container, @article_container)
        @app.sitemap.register_resource_list_manipulator(:archives, @archives)
        @app.sitemap.register_resource_list_manipulator(:index_creator, @index_creator)
=end

#        binding.pry
      end
    end
  end
end
