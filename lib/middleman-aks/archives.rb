require 'middleman-aks/processor'

module Middleman
  module Aks
    class Archives < Processor
      module Helpers
        ## archvies helpers
        def link_to_archives(caption, type, year, month=nil)
          link_to(caption, url_for_archives(type, year, month))
        end
        def url_for_archives(type, year, month=nil)
          case type
          when :year
            config.aks_settings.archives_path_year % {year: year}
          when :month
            config.aks_settings.archives_path_month % {year: year, month: "%02d" % [month]}
          end
        end
      end

      def initialize(app, controller, options = {})
        super

        @app.helpers do
          include Helpers
        end

        require 'ostruct'
        @template = OpenStruct.new ({
          year: @app.config.aks_settings.archives_template_year,
          month: @app.config.aks_settings.archives_template_month
        })

        @app.ignore @template.year
        @app.ignore @template.month
      end
      def manipulate_resource_list(resources)
        @app.logger.debug "- archives.manipulate"
        newres = []
#        binding.pry
        year_template_exists = ! @app.sitemap.find_resource_by_path(@template.year).nil?
        month_template_exists = ! @app.sitemap.find_resource_by_path(@template.month).nil?
        
        @app.logger.debug "year: #{year_template_exists}, month: #{month_template_exists}"
        @app.controller.articles.group_by {|a| a.date.year }.each do |year, y_articles|
#        resources.group_by {|a| a.date.year }.each do |year, y_articles|
          newres << create_archives_resource(:year, year, nil, y_articles) if year_template_exists
          if month_template_exists
            y_articles.group_by {|a| a.date.month }.each do |month, m_articles|
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
          template = @template[type]
#          template = self.class.proxy_template(type)
#          template = @app.config["archives_template_#{type}".to_sym]
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
