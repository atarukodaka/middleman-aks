require "middleman-archives/version"

::Middleman::Extensions.register(:archives) do
  require 'middleman-archives/extension'
  ::Middleman::Archives::Extension
end
