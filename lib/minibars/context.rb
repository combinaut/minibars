# frozen_string_literal: true

module Minibars
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
end
