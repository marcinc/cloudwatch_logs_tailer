module CloudwatchLogsTailer
  module Handlers
    class Stdout

      def self.process(event)
        puts "-- #{event.inspect}"
      end

    end
  end
end
