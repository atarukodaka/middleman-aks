module Middleman
  module Aks
    class Archives
      @proxy_templates = {
        year: "/archives_template_year.html",
        month: "/archives_template_month.html"
      }
      @output_path_formats = {
        year: "/archives/%{year}/index.html",
        month: "/archives/%{year}/%{month}.html"
      }
      class << self
        def proxy_template(type)
          @proxy_templates[type]
        end
        def output_path_format(type)
          @output_path_formats[type]
        end
        def set_proxy_template(type, value)
          @proxy_templates[type] = value
        end
        def set_output_path_format(type, value)
          @output_path_formats[type] = value
        end
      end

      module Helpers
        ## archvies helpers
        def link_to_archives(caption, type, year, month=nil)
          link_to(caption, url_for_archives(type, year, month))
        end
        def url_for_archives(type, year, month=nil)
          case type
          when :year
            Middleman::Aks::Archives.output_path_format(:year) % {year: year}
          when :month
            Middleman::Aks::Archives.output_path_format(:month) % {year: year, month: "%02d" % [month]}
          end
        end
      end

      def initialize(app, ext, options = {})
        @app = app
        @ext = ext

        @app.helpers do
          include Middleman::Aks::Archives::Helpers
        end
        app.logger.debug :foo

        @app.ignore self.class.proxy_template(:year)
        @app.ignore self.class.proxy_template(:month)

      end
      def manipulate_resource_list(resources)
        @app.logger.debug "- archives.manipulate"
        newres = []
#        binding.pry
        @app.controller.articles.group_by {|a| a.date.year }.each do |year, y_articles|
#        resources.group_by {|a| a.date.year }.each do |year, y_articles|
          if File.exists?(self.class.proxy_template(:year))
            newres << create_archives_resource(:year, year, nil, y_articles)
          end
          y_articles.group_by {|a| a.date.month }.each do |month, m_articles|
            if File.exists?(self.class.proxy_template(:month))
              newres << create_archives_resource(:month, year, month, m_articles)
            end
          end
        end
        resources + newres
      end

      private
      def create_archives_resource(type, year, month, articles)
        path = @app.url_for_archives(type, year, month).sub(/^\//, '')
         Sitemap::Resource.new(@app.sitemap, path).tap do |p|
          template = self.class.proxy_template(type)
          p.proxy_to(template)
          p.add_metadata locals: {
            year: year,
            month: month,
            articles: articles
          }
        end
      end
    end ## class Archives
  end
end
