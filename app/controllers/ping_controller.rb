class PingController < ApplicationController

  def index
    render nothing: true, status: 200, content_type: "application/json"
  end

end
