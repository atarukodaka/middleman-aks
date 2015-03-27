require "middleman-core"
require "middleman-aks/template"
require "middleman-aks/version"


::Middleman::Extensions.register(:aks) do
  require 'middleman-aks/extension'
  ::Middleman::Aks::Extension
end
