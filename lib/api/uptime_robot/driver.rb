class API::UptimeRobot::Driver
  def self.monitors_status

    url = base_url+'/getMonitors'
    params = format

    response = call url, params
    JSON.parse(response.gsub('jsonUptimeRobotApi(', '').gsub(')', ''))
  end

  private

  def self.call(url, params = {})
    params.merge! api_key

    verify_ssl_mode = OpenSSL::SSL::VERIFY_NONE

    RestClient::Resource.new(
        url,
        verify_ssl: verify_ssl_mode
    ).get(params: params)
  end


  def self.base_url
    'https://api.uptimerobot.com'
  end

  def self.api_key
    {apiKey: UptimeRobot[:key]}
  end

  def self.format
    {format: 'json'}
  end
end