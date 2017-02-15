class Api::UptimeController < ApplicationController

  STATUS = {
      '0' => 'PAUSED',
      '1' => 'NOT CHECKED YET',
      '2' => 'UP',
      '8' => 'SEEMS DOWN',
      '9' => 'DOWN'
  }

  def all
    render json: {
               acoss: status(:acoss),
               infogreffe: status(:infogreffe),
               insee: status(:insee),
               apientreprise: status(:apientreprise),
               qualibat: status(:qualibat),
               mps: status(:mps),
               tps: status(:tps)
           }
  end

  def taux_dispo
    render json: {taux_dispo: infos(:apientreprise)[:customuptimeratio]}
  end

  def acoss
    render_json_status :acoss
  end

  def infogreffe
    render_json_status :infogreffe
  end

  def insee
    render_json_status :insee
  end

  def qualibat
    render_json_status :qualibat
  end

  def apientreprise
    render_json_status :apientreprise
  end

  def tps
    render_json_status :tps
  end

  def mps
    render_json_status :mps
  end

  private

  def render_json_status(api)
    render json: {status: status(api)}
  end

  def status(api)
    STATUS[infos(api)[:status]] || 'NULL'
  end

  def infos(api)
    monitors.select{ |monitor| monitor[:id] == UptimeRobot[:monitors][api] }.first || {}
  end

  def monitors
    @monitors ||= API::UptimeRobot::Adapter.monitors_status[:monitors]
  end
end
