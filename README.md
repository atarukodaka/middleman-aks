# Middleman::Aks

middleman-aks is a template of Middleman with some extensions to manage Markdown Files efficiently.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'middleman-aks'
```

And then execute:

```sh
$ bundle
or
$ bundle install --path vendor/bundle
```

Or install it yourself as:

```
$ gem install middleman-aks
```

## Usage

```
$ middleman init PROJECT --template aks
```

## Contributing

1. Fork it ( https://github.com/atarukodaka/middleman-aks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## TODO

### easy to get it done
- setup template files

### okey, lets just do
- site_tree
  - children_pages for index-summary
  - sitemap.html.erb
  - partials/summary
  - hierarchy for each article
  - exclude archives from the tree
- add more features/fixtures to test
- article info

### need to think abt it


### lower priority

- pager, paginate
- partial or helper for share_sns
- tags



### sitemap dropdown
<ul style="display: block">
  <li aria-expanded="true" class=""><a class="pointer" data-toggle="collapse" data-target="#target1" aria-expanded="false">[+]</a>asdf</li>

    <ul id="target1" class="collapse in" aria-expanded="true" style="">
      <li>hge</li>
    </ul>

</ul>
