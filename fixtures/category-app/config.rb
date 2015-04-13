activate :blog do |blog|
  blog.prefix = ""
  blog.sources = "{category}/{title}.html"
  blog.permalink = "{category}/{title}.html"
  blog.layout = "article"
end

activate :aks
