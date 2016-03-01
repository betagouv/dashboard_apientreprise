class Api::Statistiques::Dossiers::TpsController < ApplicationController
  def index
    render json: API::TPS::Driver.dossiers_statistiques
  end
end