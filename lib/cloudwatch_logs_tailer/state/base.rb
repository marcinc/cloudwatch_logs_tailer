module CloudwatchLogsTailer
  module State
    class Base

      class << self

        def set event
          raise NotImplementedError, "State manager must implement `.set` method."
        end

        def get
          raise NotImplementedError, "State manager must implement `.get` method."
        end

        private

        def get_next_start_time event, &block
          start_time = event.timestamp + 1
          yield(start_time) if block_given?
          start_time
        end

      end
    end
  end
end
