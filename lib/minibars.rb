# frozen_string_literal: true

require 'json'
require 'mini_racer'
require 'handlebars/source'

require_relative 'minibars/safe_string'

# Make use of Handlebars templates from Ruby using mini_racer
module Minibars
  class Error < RuntimeError; end
  EMPTY_HASH = {}.freeze
  private_constant :EMPTY_HASH

  # A context for compiling handlebars templates, registering partials, and loading helpers.
  #
  # @example
  #   minibars = Minibars::Context.new
  #   template = minibars.compile("{{say}} {{what}}")
  #   template.call(:say => "Hey", :what => "Yuh!") #=> "Hey Yuh!"
  class Context
    # Instantiate a new Minibars context, optionally, specify a handlebars file to load.
    #
    # @param handlebars_file [String]
    def initialize(handlebars_file: Handlebars::Source.bundled_path)
      @js = MiniRacer::Context.new.tap do |js|
        js.load(handlebars_file)
      end
    end

    # Compile the given template string and return a template object.
    #
    # @param template [String]
    # @raise [Minibars::Error] if the template is not a string
    #
    # @return [Minibars::Template]
    def compile(template)
      Template.compile(self, @js, template)
    end

    # Register the partial with the given name.
    #
    # @example
    #   minibars.register_partial("whoami", "I am {{who}}")
    #   minibars.compile("{{>whoami}}").call(:who => 'Legend') #=> I am Legend
    #
    # @param name [String] partial name
    # @param partial [String] partial content
    #
    # @raise [Minibars::Error] if the name or the partial content are not strings
    # @return [Minibars::Context]
    def register_partial(name, partial)
      raise Error, 'Partial name should be a string'    unless name.is_a?(String)
      raise Error, 'Partial content should be a string' unless partial.is_a?(String)

      @js.eval("Handlebars.registerPartial(#{name.to_json}, #{partial.to_json})")

      self
    end

    # Load JavaScript handlebars helpers from the directory specified by the given glob pattern.
    #
    # @example
    #   minibars.load_helpers("#{__dir__}/javascripts/helpers/**/*.js")
    #
    # @see https://rubyapi.org/3.1/o/dir#method-c-glob Dir.glob
    #
    # @param helpers_pattern [String]
    #
    # @return [Minibars::Context]
    def load_helpers(helpers_pattern)
      Dir[helpers_pattern].each do |path|
        load_helper(path)
      end

      self
    end

    # Load a handlebars helper from a single JavaScript file.
    #
    # @example
    #   minibars.load_helper("#{__dir__}/javascripts/helpers/admin.js")
    #
    # @param path [String]
    #
    # @return [Minibars::Context]
    def load_helper(path)
      @js.load(path)

      self
    end
  end

  # A compiled handlebars template.
  class Template
    attr_reader :content, :name

    # @api private
    def self.compile(context, js, content)
      new(context, js, content).compile
    end

    # @api private
    def initialize(context, js, content)
      @content = content
      @context = context
      @js      = js
      @name    = "Minibars_Template_#{hash_combine(@context.hash, @content.hash).abs}"
    end

    # @api private
    def compile
      raise Error, 'Template content should be a string' unless content.is_a?(String)

      @js.eval("#{name} = Handlebars.compile(#{content.to_json})")

      self
    end

    # Render the template with the given parameters.
    #
    # @param params [Hash]
    #
    # @return [String]
    def call(params = EMPTY_HASH)
      @js.eval("#{name}(#{JSON.generate process_params(params)})")
    end

    private

    def process_params(params)
      return params if params.empty?

      params.transform_values do |value|
        if value.respond_to?(:call)
          value.call
        else
          value
        end
      end
    end

    def hash_combine(seed, hash)
      # a la boost, a la clojure
      seed ^= hash + 0x9e3779b9 + (seed << 6) + (seed >> 2)
      seed
    end
  end
end

# Let's be as Handlebars.rb compatible as we can!
  module Handlebars
    Context = Minibars::Context unless defined? Context
    SafeString = Minibars::SafeString unless defined? SafeString
  end