require 'middleman-aks/processor'

module Middleman
  module Aks
    # == Archive Manager Class
    #
    # create archives pages, e.g. if a page dated 2015-3-1 on frontmatter exists,
    # an instance of this class creates:
    #   /archives/2015/index.html  as per year template
    #   /archives/2015/03.html     as per month template
    #
    # in default, template files are located at:
    #   year:  source/templates/archives_template_year.html.erb
    #   month: source/templates/archives_template_month.html.erb
    #
    class ArchiveManager < Processor
      module Helpers
        def link_to_archives(caption, type, year, month = nil)
          link_to(h(caption), aks.processors.archives.url_for(type, year, month))
        end
      end
      ################
      def initialize(app, controller, options = {})
        super

        settings = app.config.aks_settings
        require 'ostruct'
        @template = OpenStruct.new ({year: settings.archives_template_year,
                                      month: settings.archives_template_month})

        @path_template = OpenStruct.new ({year: settings.archives_path_year,
                                           month: settings.archives_path_month})

        # ignore templates
        app.ignore @template.year
        app.ignore @template.month
      end
      def url_for(type, year, month = nil)
        return nil if [:year, :month].grep(type).empty?
        
        params = {
          year: '%04d' % [year.to_i],
          month: '%02d' % [month.to_i]
        }
        return @path_template[type] % params
      end

      ################
      # add proxy pages for year/month archives if temlate files exist.
      # this returns the given resources and additional proxy pages.
      #
      def manipulate_resource_list(resources)
        app.logger.debug '- archives.manipulate'
        newres = []

        year_template_exists = ! @app.resource_for(@template.year).nil?
        month_template_exists = ! @app.resource_for(@template.month).nil?
        
        controller.pages(resources).group_by {|page| page.date.year }.each do |year, y_articles|
          if year_template_exists
            newres << create_archives_page(:year, year, nil, y_articles)
          end
          if month_template_exists
            y_articles.group_by {|page| page.date.month }.each do |month, m_articles|
              newres << create_archives_page(:month, year, month, m_articles)
            end
          end
        end
        resources + newres
      end

      ################
      private
      def create_archives_page(type, year, month=nil, pages)
        month ||= 1
        path = url_for(type, year, month).sub(/^\//, '')
        data = {
          locals: {
            year: year,
            month: month,
            pages: pages
          },
          page: {
            "date" => Date.new(year, month, 1)
          }
        }
        controller.create_proxy_page(path, @template[type], data)
      end
    end ## class Archives
  end
end
################################################################
