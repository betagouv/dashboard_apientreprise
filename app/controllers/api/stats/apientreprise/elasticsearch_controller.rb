class Api::Stats::Apientreprise::ElasticsearchController < ApplicationController

  def requests_last_hour
    render json: API::Elasticsearch::Adapter.monitor_requests
  end

  def last_requests
    render json: API::Elasticsearch::Adapter.monitor_last_requests
  end

  def last_30_days_requests
    render json: API::Elasticsearch::Adapter.monitor_last_30_days_requests
  end

end