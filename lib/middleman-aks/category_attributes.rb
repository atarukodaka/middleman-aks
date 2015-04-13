
module Middleman::Aks
  class CategoryAttributes
    module InstanceMethodsToBlogData
      def categories
        @categories ||= articles.group_by {|p| p.category }.reject {|c, a| c.nil?}
      end
    end ## module InstanceMethodsToBlogData
    module InstanceMethodsToBlogArticle
      def category
        return self.data.category || self.metadata[:page]["category"]
      end
    end
    ################
    class << self
      def activate
        Middleman::Blog::BlogArticle.class_eval do
          include InstanceMethodsToBlogArticle
        end
        Middleman::Blog::BlogData.class_eval do
          include InstanceMethodsToBlogData
        end
      end
    end
  end 
end ## module Middleman::Aks
