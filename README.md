# CloudwatchLogsTailer

* Tails events for specified log group. 
* Tails events from specific point in time (or from the beginning). 
* Event stream can be limited to specific log streams. 
* Multiple handlers can be applied to each streamed event.
* Once tailer exhausted current log events it'll wait specified amount of time before the next poll (see `sleep_time` below).

## Installation

Add this line to your application's Gemfile:

    gem 'cloudwatch_logs_tailer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloudwatch_logs_tailer

## AWS Configuration

### Region
You can configure a default region in the following locations:

* `ENV['AWS_REGION']`
* `Aws.config[:region]`

### Credentials
Default credentials are loaded automatically from the following locations:

* `ENV['AWS_ACCESS_KEY_ID']` and `ENV['AWS_SECRET_ACCESS_KEY']`
* `Aws.config[:credentials]`
* The shared credentials ini file at [~/.aws/credentials](http://blogs.aws.amazon.com/security/post/Tx3D6U6WSFGOK2H/A-New-and-Standardized-Way-to-Manage-Credentials-in-the-AWS-SDKs)
* From an instance profile when running on EC2

## Usage

```ruby
consumer = CloudwatchLogsTailer::Client.new(log_group_name: "/log/group/name")
consumer.tail(
  handlers: [
    CloudwatchLogsTailer::Handlers::Stdout,
    YourOwnHandlerClass
  ],
  start_time: "2 hours ago"
)
```  

`CloudwatchLogsTailer::Client` constructor takes the following argument hash:
```ruby
{
  log_group_name: "your_log_group_name",
  stream_names: ["stream1", "stream2"],
  limit: 200,
  filter_pattern: "messageFilter",
  sleep_time: 3600,
  state_manager: YourOwnStateManager
} 
```

##### Required

* `log_group_name` - Cloudwatch log group name.

##### Optional 

* `stream_names` - List of log stream names within the specified log group to search.
* `limit` - The maximum number of events to return in a page of results. Defaults to `10,000`.
* `filter_pattern` - A valid CloudWatch Logs filter pattern to use for filtering the response. If not provided, all the events are matched.
* `sleep_time` - Amount of time the consumer waits before next poll, after exhausting all events from the stream. Defaults to `3600` seconds.
* `state_manager` - Internal state management class. It's responsible for storing/retrieving `start_time` of the next event to be fetched from Cloudwatch Logs. If not specified it'll use a built in state manager. `state_manager` instructs consumer to pull events from the beginning if state hasn't been persisted yet.


### tail

`tail` takes the following hash of ___optional___ arguments:

* `handlers` - A list of event handler classes. If not speficied it'll default to built in Stdout handler.
* `start_time` - Initial point in time (timestamp) from which events should be fetched. If present it takes presedence over initial timestamp set by the `state_manager`. Value for this argument can be [expressed in natural language](https://github.com/mojombo/chronic/#examples).


## Handlers

Consumer accepts list of handlers to be applied to each event. 
Custom event handlers must implement `.process` method which deals with event processing. Example below:

```ruby
class ExampleHandler
  
  def self.process(event)
    # your custom event processing logic
  end

end
```

## State manager

Consumer takes optional state manager which is responsible for storing / retrieving next `start_time` from which events should be fetched from Cloudwatch logs. Example below:

```ruby
class ExampleStateManager < CloudwatchLogsTailer::State::Base
  
  def self.set(event)
    get_next_start_time(event) do |next_start_time|
      # store next_start_time somewhere
    end
  end

  def self.get
    # retrieve and return next_start_time
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
