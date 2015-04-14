activate :blog do |blog|
  blog.prefix = ""
  blog.sources = "{category}/{title}.html"
  blog.permalink = "{category}/{title}.html"
  blog.layout = "article"

  blog.paginate = true
  blog.page_link = "p{num}"
  blog.per_page = 10
end

activate :aks
