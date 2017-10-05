require 'fluent/plugin/conditional_filter_rule'
class Fluent::ConditionalFilterOutput < Fluent::Output
  Fluent::Plugin.register_output('conditional_filter', self)

  # Define `router` method of v0.12 to support v0.10 or earlier
  unless method_defined?(:router)
    define_method("router") { Fluent::Engine }
  end

  include Fluent::HandleTagNameMixin
  include Fluent::ConditionalFilterRule

  config_param :key_pattern, :string
  config_param :condition,   :string
  config_param :filter,      :string

  def configure(conf)
    super

    not_configured_params = %w[key_pattern condition filter].select { |p| !send(p.to_sym) }
    if not_configured_params.any?
      raise Fluent::ConfigError(
        "[out_conditional_filter] missing mandatory parameter: #{not_configured_params.join(',')}"
      )
    end

    @key_pattern_regexp = Regexp.new(key_pattern)
  end

  def emit(tag, es, chain)
    es.each do |time, record|
      t = tag.dup
      record = filter_record(t, time, record, self)

      if record.any?
        router.emit(t, time, record)
      end
    end

    chain.next
  end
end
