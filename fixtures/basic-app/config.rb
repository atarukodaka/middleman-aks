activate :blog do |blog|
  blog.prefix = ""
  blog.sources = "{category}/{title}.html"
  blog.permalink = "{category}/{title}.html"
  blog.layout = "article"

  blog.paginate = true
  blog.page_link = "p{num}"
  blog.per_page = 10

  blog.custom_collections = {
    category: {
      link: '/categories/{category}.html',
      template: '/proxy_templates/category_template.html'
    }
  }
  
end

activate :aks
