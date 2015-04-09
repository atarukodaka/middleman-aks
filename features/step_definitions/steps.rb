################
Given /^an index_template exists$/ do
  content =<<EOS
---
---

<% page ||= current_page %>

<% content_for(:title, page_title(page)) %>

<ul>
  <% page.children.each do |child| %>
  <li><%= link_to_page(child) %></li>
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

<% pages.group_by {|a| page_date(a).month }.each do |month, month_pages| %>
<h3><%= link_to_archives(Date.new(year, month, 1).strftime("%b"), :month, year, month) %></h3>
<ul>
  <% month_pages.each do |page| %>
  <li><%= link_to(page.data.title, page) %></li>
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

<% pages ||= [] %>

<% content_for(:title) { "Archives for %s" % [Date.new(year, month, 1).strftime("%b %Y")] } %>

<ul>
<% pages.each do |page| %>
<li><%= link_to(page.data.title, page) %>
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
