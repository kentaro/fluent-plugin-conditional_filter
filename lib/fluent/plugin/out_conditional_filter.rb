class Fluent::ConditionalFilterOutput < Fluent::Output
  Fluent::Plugin.register_output('conditional_filter', self)

  include Fluent::HandleTagNameMixin

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
      record = filter_record(t, time, record)

      if record.any?
        Fluent::Engine.emit(t, time, record)
      end
    end

    chain.next
  end

  private

  def filter_record(tag, time, record)
    case filter
    when 'numeric_upward'
      filter_record = record.select do |key, value|
        key.match(@key_pattern_regexp) &&
          record[key].to_f >= condition.to_f
      end
    else
      raise ArgumentError.new("[out_conditional_filter] no such filter: #{filter}")
    end

    filter_record
  end
end


