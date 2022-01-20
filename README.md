# Minibars

A (mostly) drop-in replacement for [Handlebars.rb][3] based on [MiniRacer][1] rather than [therubyracer][2].

An appropriately revised quote from the [Handlebars.rb][3] README:

> This uses ~~therubyracer~~[MiniRacer][1] to bind to the _actual_ JavaScript implementation of [Handlebars.js](https://github.com/handlebars-lang/handlebars.js) so that you can use it from ruby.

# Why?

Minibars is a stripped down implmentation of [Handlerbars.rb][3] using [MiniRacer][1]. It eschews capabilities that require two-way binding with the JS runtime, making it a good upgrade path for those with simple Handlebars templates who need an upgrade path for their ARM64 architecture.

# Why?

Minibars is a stripped down implmentation of Handlerbars using MiniRacer. It eschews capabilities that require two-way binding with the JS runtime, making it a good upgrade path for those with simple Handlebars templates who need an upgrade path for their ARM64 architecture.

# Usage

## Simple Stuff

```ruby
require 'minibars'
minibars = Minibars::Context.new
template = minibars.compile("{{say}} {{what}}")
template.call(:say => "Hey", :what => "Yuh!") #=> "Hey Yuh!"
```

## Helpers

JavaScript helpers can be loaded as individual files or as a glob

```ruby
minibars.load_helpers("#{__dir__}/javascripts/helpers/**/*.js")
minibars.load_helper("#{__dir__}/javascripts/helpers/admin.js")
```

## Partials

You can directly register partials

```ruby
minibars.register_partial("whoami", "I am {{who}}")
minibars.compile("{{>whoami}}").call(who: 'Legend') #=> I am Legend
```

## SafeStrings

By default, handlebars will escape strings that are returned by your block helpers. To mark a string as safe:

```ruby
template = minibars.compile("{{safe}}")
template.call(safe: Minibars::SafeString.new("<pre>Totally Safe!<pre>"))
```

## Limitations

- No Ruby helpers
- No functions as properties
- No safe strings for now

## Security

In general, you should not trust user-provided templates: a template can call any method (with no arguments) or access any property on any object in the `Minibars::Context`.

If you'd like to render user-provided templates, you'd want to make sure you do so in a sanitized Context, e.g. no filesystem access, read-only or no database access, etc.

[1]: https://github.com/rubyjs/mini_racer
[2]: https://github.com/rubyjs/therubyracer
[3]: https://github.com/cowboyd/handlebars.rb
