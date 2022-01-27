# 0.2.0

## More Handlebars.rb compatibility

When `require "handlebars"` is called `Handlebars::Context` aliases `Minibars::Context` and `Handlebars::SafeString` aliases `Minibars::SafeString` unless they are already defined.
