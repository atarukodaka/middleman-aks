#
# This makefile is for development purpose
#

VERSION = `ruby -r ./lib/middleman-aks/version -e 'puts Middleman::Aks::VERSION'`
GEMSPEC = middleman-aks.gemspec
GEMFILE = middleman-aks-$(VERSION).gem

TEMPLATE_NAME = aks
PROJECT_DIR = $(TEMPLATE_NAME)-proj

build_gem:
	gem build $(GEMSPEC)


install_gem: build_gem
	gem install $(GEMFILE)

init:  install_gem
	middleman init $(PROJECT_DIR) --template $(TEMPLATE_NAME)

build:  
	(cd $(PROJECT_DIR); bundle exec middleman build --verbose)

server : 
	(cd $(PROJECT_DIR); bundle exec middleman server --verbose --force-polling)

console:
	(cd $(PROJECT_DIR); bundle exec middleman console --verbose)

reflect_source:
	cp -r $(PROJECT_DIR)/source/* lib/middleman-aks/template/source

mastering:
	git status
	read confirm
	git checkout master
	git merge devel
	git checkout devel
	git push origin master
	git push origin devel
	git branch
