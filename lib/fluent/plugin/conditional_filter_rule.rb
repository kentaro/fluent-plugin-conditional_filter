require 'fluent/output'

module Fluent
  module ConditionalFilterRule
    def filter_record(tag, time, record, plugin)
      super(tag, time, record) if plugin.is_a?(Fluent::Output)
      case @filter
      when 'numeric_upward'
        filter_record = record.select do |key, value|
          key.match(@key_pattern_regexp) &&
            record[key].to_f >= @condition.to_f
        end
      when 'numeric_downward'
        filter_record = record.select do |key, value|
          key.match(@key_pattern_regexp) &&
            record[key].to_f <= @condition.to_f
        end
      when 'string_match'
        filter_record = record.select do |key, value|
          key.match(@key_pattern_regexp) &&
            record[key].match(Regexp.new(@condition))
        end
      else
        raise ArgumentError.new("[conditional_filter_rule] no such filter: #{filter}")
      end

      filter_record
    end
  end
end
