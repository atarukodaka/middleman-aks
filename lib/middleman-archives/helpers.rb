module Middleman
  module Archives
    module Helpers
      def link_to_archives(caption, type, year, month=nil)
        link_to(caption, url_to_archives(type, year, month))
      end
      def url_to_archives(type, year, month=nil)
        case type
        when :year
          config[:archives_settings][:output_path_year] % {year: year}
        when :month
          config[:archives_settings][:output_path_month] % {year: year, month: "%02d" % month}
        end
      end
    end
  end
end
