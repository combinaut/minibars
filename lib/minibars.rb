# frozen_string_literal: true

require 'mini_racer'
require 'json'

module Minibars
  class Error < RuntimeError; end
  EMPTY_HASH = {}.freeze

  class Context
    HANDLE_BARS_FILE = Pathname.new(__dir__).join('../vendor/javascript/handlebars.js')

    attr_reader :js

    def initialize(handlebars_file: nil)
      @js = MiniRacer::Context.new.tap do |js|
        js.load(handlebars_file || HANDLE_BARS_FILE)
      end
    end

    def compile(content)
      Template.compile(self, content)
    end

    def register_partial(name, content)
      raise Error, 'Partial name should be a string'    unless name.is_a?(String)
      raise Error, 'Partial content should be a string' unless content.is_a?(String)

      @js.eval("Handlebars.registerPartial(#{name.to_json}, #{content.to_json})")

      self
    end

    def load_helpers(helpers_pattern)
      Dir[helpers_pattern].each do |path|
        load_helper(path)
      end

      self
    end

    def load_helper(path)
      @js.load(path)

      self
    end
  end

  class Template
    attr_reader :content, :name

    def self.compile(context, content)
      new(context, content).compile
    end

    def initialize(context, content)
      @content = content
      @context = context
      @name    = "Minibars_Template_#{hash_combine(@context.hash, @content.hash).abs}"
    end

    def compile
      raise Error, 'Template content should be a string' unless content.is_a?(String)

      @context.js.eval("#{name} = Handlebars.compile(#{content.to_json})")

      self
    end

    def call(params = EMPTY_HASH)
      @context.js.eval("#{name}(#{JSON.generate params})")
    end

    private

    def hash_combine(seed, hash)
      # a la boost, a la clojure
      seed ^= hash + 0x9e3779b9 + (seed << 6) + (seed >> 2)
      seed
    end
  end
end
