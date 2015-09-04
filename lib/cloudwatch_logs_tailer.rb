require_relative "cloudwatch_logs_tailer/version"
require_relative "cloudwatch_logs_tailer/handlers"
require_relative "cloudwatch_logs_tailer/state"
require "aws-sdk"
require "chronic"

module CloudwatchLogsTailer
  class Client

    CLOUDWATCHLOGS_CLIENT = Aws::CloudWatchLogs::Client.new

    def initialize(args)
      @log_group_name = args.fetch(:log_group_name)
      @stream_names = args.fetch(:stream_names, [])
      @filter_pattern = args.fetch(:filter_pattern, nil)
      @limit = args.fetch(:limit, 10_000) 
      @sleep_time = args.fetch(:sleep_time, 3600)
      @state_manager = args.fetch(:state_manager, State::Manager)
    end

    def tail(args = {})
      handlers = args.fetch(:handlers, [Handlers::Stdout])
      start_time = args.fetch(:start_time, @state_manager.get)

      if start_time.is_a? String
        start_time = Chronic.parse(start_time).to_i * 1000
      end

      next_token = nil
      loop do 
        res = fetch_events(start_time, next_token)
        events = res.events
        events_count = events.size
        events.each.with_index(1) do |event, index|
          handlers.each do |h|
            h.process(event)
          end
          start_time = @state_manager.set(event) if index == events_count
        end

        if res.next_token
          next_token = res.next_token
        else
          next_token = nil
          puts "* Sleeping for #{@sleep_time}sec..."
          sleep(@sleep_time.to_i)
        end
      end
    end

    private

    def fetch_events(start_time, next_token = nil)
      args = {
        log_group_name: @log_group_name, 
        interleaved: true, 
        limit: @limit.to_i,
        start_time: start_time.to_i
      }
      args.merge(next_token: next_token) unless next_token.nil?
      args.merge(log_stream_names: @stream_names) unless @stream_names.empty?
      args.merge(filter_pattern: @filter_pattern) unless @filter_pattern.nil?
      CLOUDWATCHLOGS_CLIENT.filter_log_events(args)
    end     

  end
end
