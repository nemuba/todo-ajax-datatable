# frozen_string_literal: true

# Helper para testes de performance de queries
module QueryCounter
  extend RSpec::Matchers::DSL

  matcher :exceed_query_limit do |expected|
    supports_block_expectations

    match do |block|
      query_count = count_queries(&block)
      @actual_count = query_count
      query_count > expected
    end

    failure_message do
      "Expected to run maximum #{expected} queries, but ran #{@actual_count}"
    end

    failure_message_when_negated do
      "Expected to run more than #{expected} queries, but ran #{@actual_count}"
    end

    def count_queries(&block)
      count = 0

      counter = lambda do |_name, _started, _finished, _unique_id, payload|
        count += 1 unless %w[CACHE SCHEMA].include?(payload[:name])
      end

      ActiveSupport::Notifications.subscribed(counter, 'sql.active_record', &block)

      count
    end
  end
end

RSpec.configure do |config|
  config.include QueryCounter
end
