# Handlebars Compatibility
# Allows Minibars to be a drop in replacement for Handlebars (minus features that are not supported)
require 'minibars'

module Handlebars
  Context = Minibars::Context unless defined? Context
  SafeString = Minibars::SafeString unless defined? SafeString
end
