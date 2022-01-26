# frozen_string_literal: true

module Minibars
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
