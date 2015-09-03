module CloudwatchLogsTailer
  module State
    class Manager < Base
    
      @start_time ||= 1

      class << self

        def set(event)
          @start_time = get_next_start_time(event) do |start_time|
            puts "-- Next `start_time`: #{start_time}"
          end
        end

        def get
          @start_time
        end

      end

    end
  end
end
