require 'spec_helper'

describe Api::UptimeController, type: :controller do
  before do
    stub_request(:get, "https://api.uptimerobot.com/getMonitors?apiKey=#{UptimeRobot[:key]}&format=json").
        to_return(:status => 200, :body => File.read('spec/supports/uptime_robot_response.json'), :headers => {})
  end

  subject { JSON.parse(response.body) }

  describe 'GET all' do
    before do
      get :all
    end

    it { expect(subject['acoss']).to eq 'UP' }
    it { expect(subject['infogreffe']).to eq 'UP' }
    it { expect(subject['insee']).to eq 'UP' }
    it { expect(subject['apientreprise']).to eq 'UP' }
    it { expect(subject['qualibat']).to eq 'UP' }
  end

  describe 'GET taux_dispo' do
    before do
      get :taux_dispo
    end

    it { expect(subject['taux_dispo']).to eq '99.74' }
  end

  describe 'GET accoss' do
    before do
      get :acoss
    end

    it { expect(subject['status']).to eq 'UP' }
  end

  describe 'GET infogreffe' do
    before do
      get :infogreffe
    end

    it { expect(subject['status']).to eq 'UP' }
  end

  describe 'GET insee' do
    before do
      get :insee
    end

    it { expect(subject['status']).to eq 'UP' }
  end

  describe 'GET apientreprise' do
    before do
      get :apientreprise
    end

    it { expect(subject['status']).to eq 'UP' }
  end

  describe 'GET qualibat' do
    before do
      get :qualibat
    end

    it { expect(subject['status']).to eq 'UP' }
  end
end