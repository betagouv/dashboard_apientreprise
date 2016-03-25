class API::Elasticsearch::Driver

  def self.request_interval_30s(timestamp_begin, timestamp_end)
    url = base_url + '/elasticsearch/_msearch?timeout=0&ignore_unavailable=true'
    date = Time.now.strftime("%Y.%m.%d")
    query = '{"index":["logstash-' + date + '"],"search_type":"count","ignore_unavailable":true}
{"query":{"filtered":{"query":{"query_string":{"query":"controller:\"/api/v1/*\"-controller:\"*ping*\"","analyze_wildcard":true}},"filter":{"bool":{"must":[{"range":{"@timestamp":{"gte":' + timestamp_begin.to_s + ',"lte":' + timestamp_end.to_s + ',"format":"epoch_millis"}}}],"must_not":[]}}}},"size":0,"aggs":{"2":{"date_histogram":{"field":"@timestamp","interval":"30s","time_zone":"Europe/Berlin","min_doc_count":0,"extended_bounds":{"min":' + timestamp_begin.to_s + ',"max":' + timestamp_end.to_s + '}}}}}
'
    JSON.parse(call(url, query))
  end

  private

  def self.call(url, params = {})
    verify_ssl_mode = OpenSSL::SSL::VERIFY_NONE

    RestClient::Resource.new(
        url,
        verify_ssl: verify_ssl_mode,
        :headers => { "kbn-version": "4.4.1" }
    ).post params, :content_type => 'application/json'
  end


  def self.base_url
    "https://#{Kibana[:login]}:#{Kibana[:password]}@kibana.apientreprise.fr:443"
  end
end
