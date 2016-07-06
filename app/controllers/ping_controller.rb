class PingController < ApplicationController

  def index
    Rails.logger.silence do
      render nothing: true, status: 200, content_type: "application/json"
    end
  end

end
