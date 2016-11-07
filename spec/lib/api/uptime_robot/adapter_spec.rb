require 'spec_helper'

describe API::UptimeRobot::Adapter do
  describe '.monitors_status' do

    subject { described_class.monitors_status }

    before do
      stub_request(:get, "https://api.uptimerobot.com/getMonitors?apiKey=#{UptimeRobot[:key]}&customUptimeRatio=30&format=json&monitors=#{API::UptimeRobot::Driver.monitors[:monitors]}").
          to_return(:status => 200, :body => File.read('spec/supports/uptime_robot_response.json'), :headers => {})
    end

    it { expect(subject[:monitors].size).to eq 7 }

    describe 'monitors attributs' do

      subject { super()[:monitors].first }

      it { expect(subject[:id]).to eq '778056728' }
      it { expect(subject[:friendlyname]).to eq 'API - API Entreprise' }
      it { expect(subject[:url]).not_to be_nil }
      it { expect(subject[:status]).to eq '2' }
      it { expect(subject[:alltimeuptimeratio]).to eq '100' }
    end
  end
end
