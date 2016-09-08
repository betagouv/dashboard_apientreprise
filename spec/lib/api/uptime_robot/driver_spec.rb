require 'spec_helper'

describe API::UptimeRobot::Driver do
  describe '.monitors_status' do

    subject { described_class.monitors_status }

    before do
      stub_request(:get, "https://api.uptimerobot.com/getMonitors?apiKey=#{UptimeRobot[:key]}&customUptimeRatio=30&format=json&monitors=#{API::UptimeRobot::Driver.monitors[:monitors]}").
          to_return(:status => 200, :body => File.read('spec/supports/uptime_robot_response.json'), :headers => {})

      subject
    end

    it { expect(subject).not_to include 'jsonUptimeRobotApi' }
    it { expect(subject).not_to include '()' }
    it { expect(subject).not_to include ')' }
  end
end
