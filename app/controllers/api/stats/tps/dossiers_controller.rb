class Api::Stats::Tps::DossiersController < ApplicationController
  def index
    render json: API::TPS::Driver.dossiers_statistiques
  end
end