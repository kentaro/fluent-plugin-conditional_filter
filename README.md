# Fluent::Plugin::ConditionalFilter [![BuildStatus](https://secure.travis-ci.org/kentaro/fluent-plugin-conditional_filter)](http://travis-ci.org/kentaro/fluent-plugin-conditional_filter)

## Component

### ConditionalFilterOutput

fluent-plugin-conditional_filter provides a simple filter that filters out key/value pairs that don't match a condition.

## Usage

### Synopsis

```
<match test.**>
  key_pattern @example.com$
  condition   10
  filter      numeric_upward
</match>
```

### Params

#### `key_pattern` (required)

Key pattern to check.

#### `condition` (optional: default = 'http')

Condition for the filter below.

#### `filter` (required)

Set filtering strategy.

#### `remove_tag_prefix`, `remove_tag_suffix`, `add_tag_prefix`, `add_tag_suffix`

You can also use the params above inherited from [Fluent::HandleTagNameMixin](https://github.com/fluent/fluentd/blob/master/lib/fluent/mixin.rb).

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-conditional_filter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-conditional_filter

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

