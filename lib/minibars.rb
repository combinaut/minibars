# frozen_string_literal: true

require 'json'
require 'mini_racer'
require 'handlebars/source'

require 'minibars/error'
require 'minibars/context'
require 'minibars/template'

require_relative 'minibars/safe_string'

# Make use of Handlebars templates from Ruby using mini_racer
module Minibars
  EMPTY_HASH = {}.freeze
  private_constant :EMPTY_HASH
end

# Let's be as Handlebars.rb compatible as we can!
  module Handlebars
    Context = Minibars::Context unless defined? Context
    SafeString = Minibars::SafeString unless defined? SafeString
  end