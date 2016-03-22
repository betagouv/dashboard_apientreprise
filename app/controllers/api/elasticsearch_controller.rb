class Api::ElasticsearchController < ApplicationController

  def requests_last_hour
    render json: API::Elasticsearch::Adapter.monitor_requests
  end

  def last_requests
    render json: API::Elasticsearch::Adapter.monitor_last_requests
  end

end