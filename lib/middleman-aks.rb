require "middleman-aks/version"

::Middleman::Extensions.register(:archives) do
  require 'middleman-aks/extension'
  ::Middleman::Aks::Extension
end
