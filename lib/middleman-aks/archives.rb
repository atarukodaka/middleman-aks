require 'middleman-aks/processor'

module Middleman
  module Aks
    # == Archives Class
    #
    # create archives pages, e.g. if a page dated 2015-3-1 on frontmatter,
    # this class creates:
    #  /archives/2015/index.html  using year template
    #  /archives/2015/03.html     using month template
    #
    class Archives < Processor
      module Helpers
        def link_to_archives(caption, type, year, month = nil)
          link_to(caption, url_for_archives(type, year, month))
        end
        def url_for_archives(type, year, month = nil)
          case type
          when :year
            config.aks_settings.archives_path_year % { year: year }
          when :month
            config.aks_settings.archives_path_month % { year: year, month: '%02d' % [month] }
          end
        end
      end

      def initialize(app, controller, options = {})
        super

        require 'ostruct'
        @template = 
          OpenStruct.new ({year: @app.config.aks_settings.archives_template_year,
                            month: @app.config.aks_settings.archives_template_month})
        # ignore templates
        @app.ignore @template.year
        @app.ignore @template.month
      end

      ################
      # add proxy pages for year/month archives if temlate files exist
      # this returns the given resources and additional proxy pages
      #
      def manipulate_resource_list(resources)
        logger.debug '- archives.manipulate'
        newres = []

        year_template_exists = ! @app.resource_for(@template.year).nil?
        month_template_exists = ! @app.resource_for(@template.month).nil?
        
        logger.debug "year: #{year_template_exists}, month: #{month_template_exists}"
        
        controller.pages.group_by {|a| a.date.year }.each do |year, y_articles|
          newres << create_archives_page(:year, year, nil, y_articles) if year_template_exists
          if month_template_exists
            y_articles.group_by {|a| a.date.month }.each do |month, m_articles|
              newres << create_archives_page(:month, year, month, m_articles)
            end
          end
        end
        resources + newres
      end

      ################
      private
      def create_archives_page(type, year, month, articles)
        path = @app.url_for_archives(type, year, month).sub(/^\//, '')
        locals = {
          year: year,
          month: month,
          articles: articles
        }
        controller.create_proxy_page(path, @template[type], locals)
      end
    end ## class Archives
  end
end
################################################################
