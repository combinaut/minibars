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

    def compile(template_string)
      Template.compile(self, template_string)
    end

    private

    JS_ESCAPE_MAP = {
        '\\'   => '\\\\',
        '</'   => '<\/',
        "\r\n" => '\n',
        "\n"   => '\n',
        "\r"   => '\n',
        '"'    => '\\"',
        "'"    => "\\'",
        '`'    => '\\`',
        '$'    => '\\$'
      }.freeze

    private_constant :JS_ESCAPE_MAP

    def escape_javascript(javascript)
      javascript = javascript.to_s
      if javascript.empty?
        ''
      else
        javascript.gsub(
          %r{(\\|<\/|\r\n|\342\200\250|\342\200\251|[\n\r"']|[`]|[$])}u,
          JS_ESCAPE_MAP
        )
      end
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
