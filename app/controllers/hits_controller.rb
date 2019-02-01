class HitsController < ApplicationController
  skip_before_action :authenticate_user!, only: :track

  def track
    tracking_id = params[:tracking_id]
    site = Site.find_by tracking_id: tracking_id

    if !site then
      head :not_found
    end

    hit = site.hits.build({
      hit_type: params[:hit_type],
      location: params[:location],
      language: params[:language],
      encoding: params[:encoding],
      title: params[:title],
      color_depth: params[:color_depth],
      screen_res: params[:screen_res],
      viewport: params[:viewport],
      tracking_id: params[:tracking_id],
      client_id: params[:client_id]
    })

    if hit.save then
      head :ok
    else
      head :unprocessable_entity
    end
  end

end
