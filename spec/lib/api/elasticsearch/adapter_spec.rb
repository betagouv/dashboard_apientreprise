require 'spec_helper'

describe API::Elasticsearch::Adapter do
  describe '.monitor_requests' do

    subject { described_class.monitor_requests }

    before do
      stub_request(:post, "https://#{Kibana[:login]}:#{Kibana[:password]}@kibana.apientreprise.fr:443/elasticsearch/_msearch?timeout=0&ignore_unavailable=true").
        with(:body => "{\"index\":[\"logstash-#{Time.now.strftime("%Y.%m.%d")}\"],\"search_type\":\"count\",\"ignore_unavailable\":true}\n{\"query\":{\"filtered\":{\"query\":{\"query_string\":{\"query\":\"controller:\\\"/api/v1/*\\\" controller:\\\"/api/v2/*\\\" -controller:\\\"/api/v1/ping\\\"\",\"analyze_wildcard\":true}},\"filter\":{\"bool\":{\"must\":[{\"range\":{\"@timestamp\":{\"gte\":1458314870938,\"lte\":1458318470938,\"format\":\"epoch_millis\"}}}],\"must_not\":[]}}}},\"size\":0,\"aggs\":{\"2\":{\"date_histogram\":{\"field\":\"@timestamp\",\"interval\":\"15s\",\"time_zone\":\"Europe/Berlin\",\"min_doc_count\":0,\"extended_bounds\":{\"min\":1458314870938,\"max\":1458318470938}}}}}\n",
             :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'568', 'Content-Type'=>'application/json', 'Kbn-Version'=>'4.4.1', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => File.read('spec/supports/elasticsearch_interval_response.json'), :headers => {})

      allow(described_class).to receive(:last_hour).and_return({ begin: 1458314870938, end: 1458318470938})
    end
    it { expect(subject[:data].size).to eq 121 }
  end

  describe '.monitor_last_requests' do

    subject { described_class.monitor_last_requests }

    before do
      stub_request(:post, "https://#{Kibana[:login]}:#{Kibana[:password]}@kibana.apientreprise.fr:443/elasticsearch/_msearch?timeout=0&ignore_unavailable=true").
        with(:body => "{\"index\":[\"logstash-#{Time.now.strftime("%Y.%m.%d")}\"],\"search_type\":\"count\",\"ignore_unavailable\":true}\n{\"size\":0,\"aggs\":{},\"query\":{\"filtered\":{\"query\":{\"query_string\":{\"analyze_wildcard\":true,\"query\":\"controller:\\\"/api/v1/*\\\" controller:\\\"/api/v2/*\\\" -controller:\\\"/api/v1/ping\\\"\"}},\"filter\":{\"bool\":{\"must\":[{\"range\":{\"@timestamp\":{\"gte\":1458314870938,\"lte\":1458318470938,\"format\":\"epoch_millis\"}}}],\"must_not\":[]}}}},\"highlight\":{\"pre_tags\":[\"@kibana-highlighted-field@\"],\"post_tags\":[\"@/kibana-highlighted-field@\"],\"fields\":{\"*\":{}},\"require_field_match\":false,\"fragment_size\":2147483647}}\n",
             :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'573', 'Content-Type'=>'application/json', 'Kbn-Version'=>'4.4.1', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => File.read('spec/supports/elasticsearch_last_requests_response.json'), :headers => {})

      allow(described_class).to receive(:last_15s).and_return({ begin: 1458314870938, end: 1458318470938})
    end
    it { expect(subject[:x]).to eq 1458318470938 }
    it { expect(subject[:y]).to eq 0 }
  end

  describe '.monitor_last_30_days_requests' do

    subject { described_class.monitor_last_30_days_requests }

    before do
      allow(DateTime).to receive(:now).and_return(DateTime.strptime("1461935563084",'%Q'))
      today = Date.today
      indexes = (today - 30 .. today).inject([]) { |init, date| init.push(date.strftime("logstash-%Y.%m.%d")) }
      stub_request(:post, "https://#{Kibana[:login]}:#{Kibana[:password]}@kibana.apientreprise.fr/elasticsearch/_msearch?ignore_unavailable=true&timeout=0").
        with(:body => "{\"index\":#{indexes.to_s},\"search_type\":\"count\",\"ignore_unavailable\":true}\n{\"size\":0,\"aggs\":{},\"query\":{\"filtered\":{\"query\":{\"query_string\":{\"analyze_wildcard\":true,\"query\":\"controller:\\\"/api/v1/*\\\" controller:\\\"/api/v2/*\\\" -controller:\\\"/api/v1/ping\\\"\"}},\"filter\":{\"bool\":{\"must\":[{\"range\":{\"@timestamp\":{\"gte\":1459343563084,\"lte\":1461935563084,\"format\":\"epoch_millis\"}}}],\"must_not\":[]}}}},\"highlight\":{\"pre_tags\":[\"@kibana-highlighted-field@\"],\"post_tags\":[\"@/kibana-highlighted-field@\"],\"fields\":{\"*\":{}},\"require_field_match\":false,\"fragment_size\":2147483647}}\n",
             :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'1263', 'Content-Type'=>'application/json', 'Kbn-Version'=>'4.4.1', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => File.read('spec/supports/elasticsearch_last_30_days_requests_response.json'), :headers => {})
    end
    it { expect(subject).to eq 430943 }
  end
end
