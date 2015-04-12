activate :blog do |blog|
  blog.prefix = "articles"
  blog.sources = "{category}/{title}.html"
  blog.layout = "article"
end

activate :aks
