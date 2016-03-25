class API::Elasticsearch::Adapter

  def self.monitor_requests
    json = API::Elasticsearch::Driver.request_interval_30s(begin_date, end_date)
    requests = Hashie::Mash.new(json).responses[0].aggregations[2].buckets

    requests = requests.inject([]) do |acc, request|
      acc.push request[:doc_count]
    end

    {name: "API Requests (30s interval)", data: requests}
  end

  def self.keep_attr_list
    [
        :doc_count
    ]
  end


  def self.begin_date
    (DateTime.now - 1.hours).strftime('%Q').to_i
  end

  def self.end_date
    DateTime.now.strftime('%Q').to_i
  end
end