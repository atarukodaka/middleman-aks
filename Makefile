#
# This makefile is for development purpose
#

GEMSPEC = middleman-aks.gemspec
GEMFILE = middleman-aks-$(VERSION).gem

TEMPLATE_NAME = aks
PROJECT_DIR = $(TEMPLATE_NAME)-proj

DEVEL_BRANCH=devel-blog

build:  
	(cd $(PROJECT_DIR); bundle exec middleman build --verbose)

server : 
	(cd $(PROJECT_DIR); bundle exec middleman server --verbose --force-polling)

console:
	(cd $(PROJECT_DIR); bundle exec middleman console --verbose)

reflect_source:
	cp $(PROJECT_DIR)/config.rb lib/middleman-aks/template/shared/config.tt
	cp $(PROJECT_DIR)/Gemfile lib/middleman-aks/template/shared/Gemfile.tt
	cp -r $(PROJECT_DIR)/source/* lib/middleman-aks/template/source

mastering:
	git status
	read confirm
	git checkout master
	git merge $(DEVEL_BRANCH)
	git checkout $(DEVEL_BRANCH)
	git push origin master
	git push origin $(DEVEL_BRANCH)
	git branch
