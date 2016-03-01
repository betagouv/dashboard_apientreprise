class API::TPS::Driver
  def self.dossiers_statistiques
    url = base_url+'/api/statistiques/dossiers'

    JSON.parse(call url)
  end

  private

  def self.call(url, params = {})
    verify_ssl_mode = OpenSSL::SSL::VERIFY_NONE

    RestClient::Resource.new(
        url,
        verify_ssl: verify_ssl_mode
    ).get(params: params)
  end


  def self.base_url
    'https://tps.apientreprise.fr'
  end
end