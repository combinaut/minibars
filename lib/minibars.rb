# frozen_string_literal: true

require 'mini_racer'
require 'json'

module Minibars
  class Context
    HANDLE_BARS_FILE = Pathname.new(__dir__).join('../vendor/javascript/handlebars.js')

    attr_reader :js
    
    def initialize
      @js = MiniRacer::Context.new.tap do |js|
        js.eval(HANDLE_BARS_FILE.read)
      end
    end

    def compile(content)
      Template.compile(self, content)
    end

    def register_partial(name, content)
      @js.eval("Handlebars.registerPartial(#{name.to_json}, #{content.to_json})")

      self
    end

    def load_helpers(helpers_pattern)
      Dir[helpers_pattern].each do |path|
        load_helper(path)
      end
    end

    def load_helper(path)
      @js.load(path)
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
      @context.js.eval("#{name} = Handlebars.compile('#{content}')")
      self
    end

    def call(params = {})
      @context.js.eval("#{name}(#{params.to_json})")
    end

    private

    def hash_combine(seed, hash)
      # a la boost, a la clojure
      seed ^= hash + 0x9e3779b9 + (seed << 6) + (seed >> 2)
      seed
    end
  end
end
