require 'fluent/plugin/conditional_filter_rule'

class Fluent::ConditionalFilter < Fluent::Filter
  Fluent::Plugin.register_filter('conditional', self)

  include Fluent::ConditionalFilterRule

  config_param :key_pattern, :string
  config_param :condition,   :string
  config_param :filter,      :string

  def configure(conf)
    super

    @key_pattern_regexp = Regexp.new(key_pattern)
  end

  def filter(tag, time, record)
    record = filter_record(tag, time, record, self)

    record if record.any?
  end
end
