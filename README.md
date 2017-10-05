# Fluent::Plugin::ConditionalFilter, a plugin for [Fluentd](http://fluentd.org) [![BuildStatus](https://secure.travis-ci.org/kentaro/fluent-plugin-conditional_filter.png)](http://travis-ci.org/kentaro/fluent-plugin-conditional_filter)

## Component

### ConditionalFilter

fluent-plugin-conditional_filter provides a simple filter that filters out key/value pairs that don't satisfy a given condition. This is the filter version of [ConditionalFilterOutput](#conditionalfilteroutput).

## Usage

### Synopsis

If there's such a configuration as below:

```
<filter test.**>
  type           conditional
  key_pattern    @example\.com$
  condition      10
  filter         numeric_upward
</filter>
```

When the log below reaches:

```
'test' => {
  'foo@example.com' => 5,
  'bar@example.com' => 15,
  'baz@baz.com'     => 12,
}
```

key/value pairs that don't match either `key_pattern` or the condition designated by `condition` and `filter` are filtered out.

```
'filtered.test' => {
  'bar@example.com' => 15,
}
```

### Params

#### `key_pattern` (required)

Key pattern to check.

#### `condition` (required)

Condition for the filter below.

#### `filter` (required)

Set filtering strategy.

### ConditionalFilterOutput

fluent-plugin-conditional_filter provides a simple filter that filters out key/value pairs that don't satisfy a given condition.

## Usage

### Synopsis

If there's such a configuration as below:

```
<match test.**>
  type           conditional_filter
  add_tag_prefix filtered.
  key_pattern    @example\.com$
  condition      10
  filter         numeric_upward
</match>
```

When the log below reaches:

```
'test' => {
  'foo@example.com' => 5,
  'bar@example.com' => 15,
  'baz@baz.com'     => 12,
}
```

key/value pairs that don't match either `key_pattern` or the condition designated by `condition` and `filter` are filtered out.

```
'filtered.test' => {
  'bar@example.com' => 15,
}
```

### Params

#### `key_pattern` (required)

Key pattern to check.

#### `condition` (required)

Condition for the filter below.

#### `filter` (required)

Set filtering strategy.

#### `remove_tag_prefix`, `remove_tag_suffix`, `add_tag_prefix`, `add_tag_suffix`

You can also use the params above inherited from [Fluent::HandleTagNameMixin](https://github.com/fluent/fluentd/blob/master/lib/fluent/mixin.rb).

### Filters

#### numeric_upward

Filter out such key/value pairs whose value aren't greater than or equal to the given value as float value.

#### numeric_downward

Filter out such key/value pairs whose value aren't smaller than or equal to the given value as float value

#### string_match

Filter out such key/value pairs whose value don't match the given value as string.

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

