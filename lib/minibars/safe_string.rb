module Minibars
  # Mark a string as safe to avoid it being escaped by Handlebars
  class SafeString
    def initialize(string)
      @string = string
    end

    # @api private
    def to_json(*)
      "new Handlebars.SafeString(#{@string.to_json})"
    end
  end
end