require 'spec_helper'

describe API::Elasticsearch::Driver do
  describe '.request_interval_30s' do

    subject { described_class.request_interval_30s(1458314870938, 1458318470938) }

    before do
      stub_request(:post, "https://#{Kibana[:login]}:#{Kibana[:password]}@kibana.apientreprise.fr:443/elasticsearch/_msearch?timeout=0&ignore_unavailable=true").
          with(:body => "{\"index\":[\"logstash-2016.03.18\"],\"search_type\":\"count\",\"ignore_unavailable\":true}\n{\"query\":{\"filtered\":{\"query\":{\"query_string\":{\"query\":\"controller:\\\"/api/v1/*\\\"-controller:\\\"*ping*\\\"\",\"analyze_wildcard\":true}},\"filter\":{\"bool\":{\"must\":[{\"range\":{\"@timestamp\":{\"gte\":1458314870938,\"lte\":1458318470938,\"format\":\"epoch_millis\"}}}],\"must_not\":[]}}}},\"size\":0,\"aggs\":{\"2\":{\"date_histogram\":{\"field\":\"@timestamp\",\"interval\":\"30s\",\"time_zone\":\"Europe/Berlin\",\"min_doc_count\":0,\"extended_bounds\":{\"min\":1458314870938,\"max\":1458318470938}}}}}\n",
               :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'536', 'Content-Type'=>'application/json', 'Kbn-Version'=>'4.4.1', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => File.read('spec/supports/elasticsearch_response.json'), :headers => {})

      subject
    end

    it { expect(subject["responses"].length).to eq(1) }
    it { expect(subject["responses"][0]["aggregations"]["2"]["buckets"].length).to eq(121) }
  end
end
