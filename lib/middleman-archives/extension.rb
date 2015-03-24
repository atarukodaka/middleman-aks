require 'middleman-archives/helpers'

module Middleman
  module Archives

=begin
    module InstanceMethodsToResource
      def title
        data.title || metadata[:page]["title"] || app.yield_content(:title)
      end
      def date
        data.date || metadata[:page]["date"] || File.ctime(source_file).try(:to_date)
      end
    end
=end
    class Extension < Middleman::Extension
#      Middleman::Sitemap::Resource.include InstanceMethodsToResource
      self.defined_helpers = [Helpers]
      
      option :proxy_template_year, "archives_template_year.html"
      option :proxy_template_month, "archives_template_month.html"
      option :output_path_year, "/archives/%{year}.html"
      option :output_path_month, "/archives/%{year}/%{month}.html"

      def initialize(app, options_hash = {}, &block)
        super
        
        app.set :archives_settings, options
       
        app.ready do
#          $stderr.puts "ready hook !!!"
#          binding.pry
          opt = config[:archives_settings]
          
          ignore opt[:proxy_template_year]
          ignore opt[:proxy_template_month]

          sitemap.resources.select {|p| p.ext == ".html" && (p.data.date || p.metadata[:page]["date"]) && !p.ignored?}.group_by {|a| a.metadata[:page]["date"].year }.each do |year, year_pages|
            proxy(opt[:output_path_year] % {year: year}, opt[:proxy_template_year],
                  :locals => {:year => year, :pages => year_pages}, :ignore => true)
            
            ## create monthly archives
            year_pages.group_by {|p| p.metadata[:page]["date"].month }.each do |month, month_pages|
              proxy(opt[:output_path_month] % {year: year, month: "%02d" % [month]}, opt[:proxy_template_month],
                    :locals => {:year => year, :month => month, :pages => month_pages})
            end
          end
        end ## ready
      end
 
      def manipulate_resource_list(resources)
        used_resources = []
#        binding.pry
        resources.each do |resource|
          if resource.ignored? || resource.ext != ".html"
          elsif ! resource.data.date && ! resource.metadata[:page]["date"]
            resource.add_metadata(page: {"date" => File.ctime(resource.source_file).to_date})
          end
          used_resources << resource
        end
        used_resources
      end
   end ## class Extension
  end ## module Archives
end
