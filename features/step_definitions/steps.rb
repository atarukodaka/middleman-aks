################
Given /^an index_template exists$/ do
  content =<<EOS
---
---

index name: <%= index_name %>

<ul>
  <% current_page.children.each do |p| %>
  <li><%= link_to(h(p.data.title || File.split(p.path).first.split("/").last), p) %></li>
  <% end %>
</ul>
EOS
  filename = "source/templates/index_template.html.erb"
  write_file(filename, content)
end

################
Given /^an archives year template exists$/ do
  content = <<EOS
---
---

<h1>Archives for <%= year %></h1>

<% articles.group_by {|a| a.date.month }.each do |month, month_articles| %>
<h3><%= link_to_archives(Date.new(year, month, 1).strftime("%b"), :month, year, month) %></h3>
<ul>
  <% month_articles.each do |article| %>
  <li><%= link_to(article.title, article) %></li>
  <% end %>
</ul>
<% end %>
EOS
  filename = "source/templates/archives_template_year.html.erb"
  write_file(filename, content)
end

################
Given /^an archives month template exists$/ do
  content = <<EOS
---
---

<% articles ||= [] %>

<% content_for(:title) { "Archives for %s" % [Date.new(year, month, 1).strftime("%b %Y")] } %>

<ul>
<% articles.each do |article| %>
<li><%= link_to(article.title, article) %>
<% end%>
</ul>
EOS
  filename = "source/templates/archives_template_month.html.erb"
  write_file(filename, content)
end

################
Given /^a sitemap page named "([^\"]*)" exists$/ do |filename|
  write_file("#{filename}", "<h2>sitemap</h2>\n<%= aks.site_tree.render %>")
end

################
Given /^a lot of pages exist$/ do
  10.times do |i|
    10.times do |j|
      10.times do |k|
        content = "---
title: # => {i}/#{j}/#{k}
---

## heading: #{i}
- a
- b
- c
"""
        write_file("source/#{i}/#{j}/#{k}.html.md", content)
      end
    end
  end
end
