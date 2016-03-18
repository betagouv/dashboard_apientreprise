class Api::ElasticsearchController < ApplicationController

  def requests_last_hour
    render json: API::Elasticsearch::Adapter.monitor_requests
  end

end