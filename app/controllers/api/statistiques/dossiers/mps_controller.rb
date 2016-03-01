class Api::Statistiques::Dossiers::MpsController < ApplicationController
  def index
    render json: API::MPS::Driver.dossiers_statistiques
  end
end