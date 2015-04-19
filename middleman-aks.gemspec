# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'middleman-aks/version'

Gem::Specification.new do |spec|
  spec.name          = "middleman-aks"
  spec.version       = Middleman::Aks::VERSION
  spec.authors       = ["Ataru Kodaka"]
  spec.email         = ["ataru.kodaka@gmail.com"]
  spec.summary       = %q{A template of Middleman to manage Markdown files efficientrly}
  spec.description   = %q{A template of Middleman to manage Markdown files efficientrly.}
  spec.homepage      = "https://github.com/atarukodaka/middleman-aks"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency("middleman-blog", "~> 3.5")
  spec.add_dependency("middleman-page-toc", "~> 0.2")
  spec.add_dependency("middleman-livereload", "~> 3.0")
  spec.add_dependency("middleman-syntax", "~> 2.0")

  spec.add_dependency("nokogiri", "~> 1.6")
  spec.add_dependency("redcarpet", "~> 3.0")
  spec.add_dependency("rouge", "~> 1.8")
    
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "cucumber", "~> 1.3"
  spec.add_development_dependency "aruba", "~> 0.6"
  spec.add_development_dependency "therubyracer", "~>0.12"
  spec.add_development_dependency "pry-byebug", "~>3.1"
  spec.add_development_dependency "rb-readline", "~>0.5"
  spec.add_development_dependency "middleman-pry", "~>0.0"
end
