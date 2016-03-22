class API::Elasticsearch::Adapter

  def self.monitor_requests
    time_range = last_hour
    json = API::Elasticsearch::Driver.count_last_requests_in_interval('15s', time_range[:begin], time_range[:end])
    requests = Hashie::Mash.new(json).responses[0].aggregations[2].buckets

    requests = requests.inject([]) do |acc, request|
      acc.push({ :x => request[:key], :y => request[:doc_count] })
    end

    { data: requests }
  end

  def self.monitor_last_requests
    time_range = last_15s
    json = API::Elasticsearch::Driver.count_last_requests(time_range[:begin], time_range[:end])
    { x: time_range[:end], y: Hashie::Mash.new(json).responses[0].hits.total }
  end

  def self.last_hour
    now = DateTime.now.strftime('%Q').to_i
    { begin: (now - 1800000), end: now }
  end

  def self.last_15s
    now = DateTime.now.strftime('%Q').to_i
    { begin: (now - 15000), end: now }
  end

end