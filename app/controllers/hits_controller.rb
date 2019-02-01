class HitsController < ApplicationController
  def create
    tracking_id = params[:tracking_id]
    site = Site.find_by tracking_id: tracking_id
    if !site then
      head :not_found
    end

    @hit = Hit.new(hit_params)

    respond_to do |format|
      if @hit.save
        format.html { redirect_to @hit, notice: 'Hit was successfully created.' }
        format.json { render :show, status: :created, location: @hit }
      else
        format.html { render :new }
        format.json { render json: @hit.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def hit_params
      params.require(:hit).permit(:hit_type, :location, :language, :encoding, :title, :color_depth, :screen_res, :viewport, :tracking_id, :client_id, :site_id)
    end
end
