require 'spec_helper'

describe CloudwatchLogsTailer::Handlers::Stdout do
  subject { CloudwatchLogsTailer::Handlers::Stdout }
  let(:event) { "My Event Data" }

  it "prints event to standard output" do
    expect($stdout).to receive(:puts).with("-- #{event.inspect}")
    subject.process(event)
  end

end
