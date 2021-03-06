class HitsController < ApplicationController
  skip_before_action :authenticate_user!, only: :track

  def track
    site_data = Site.parse_tracking_id(params[:tracking_id])

    if site_data == nil then
      head :unprocessable_entity
      return
    end

    site = Site.find(site_data[:site_id])

    if !site then
      head :not_found
      return
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
      client_id: params[:client_id],
      referer: params[:referrer]
    })

    if hit.save then
      send_file pixel_path, type: 'image/gif', disposition: 'inline'
    else
      head :unprocessable_entity
    end
  end

  private

    def pixel_path
      return Rails.root.join('public', 'pixel.gif')
    end

end
