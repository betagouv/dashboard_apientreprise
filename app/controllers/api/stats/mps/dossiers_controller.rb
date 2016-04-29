class Api::Stats::Mps::DossiersController < ApplicationController
  def index
    render json: API::MPS::Driver.dossiers_statistiques
  end
end