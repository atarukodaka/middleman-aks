module Middleman
  module PageDate
    module InstanceMethodsToResource
      def ctime
        File.exists?(source_file) ? File.ctime(source_file) : Time.now
      end
      def mtime
          File.exists?(source_file) ? File.mtime(source_file) : Time.now
      end
      def date
        data.date || metadata[:page]["date"] || ctime.to_date
      end
    end
    class Extension < Middleman::Extension
      Middleman::Sitemap::Resource.include InstanceMethodsToResource
    end
  end
end

Middleman::PageDate::Extension.register(:page_date)

