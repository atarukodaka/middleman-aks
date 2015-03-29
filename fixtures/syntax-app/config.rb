require 'rouge'
activate :aks
activate :syntax

set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :autolink => true, :smartypants => true, :tables => true

