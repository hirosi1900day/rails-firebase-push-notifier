require 'ddtrace'


service_name = 'test'
Datadog.configure do |c|
  # Agentへのデータ送信を有効化する場合、環境変数で明示的に指定する。
  c.tracing.enabled = false unless ENV.key?('DD_TRACE_ENABLED')

  c.tracing.instrument :rails, service_name: service_name
end