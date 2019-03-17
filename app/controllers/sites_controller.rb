class SitesController < ApplicationController
  before_action :set_site, only: [:show, :edit, :update, :destroy]
  before_action :user_has_site!, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to dashboard_url
  end

  def show
    @num_hits = @site.hits.length
    @hits = {
      by_day: @site.hits_by_day,
      by_week: @site.hits_by_week,
      by_month: @site.hits_by_month
    }
    render "show", layout: "site-detail"
  end

  def new
    @site = Site.new
  end

  def edit
  end

  def create
    @site = current_account.sites.build(site_params)

    if @site.save
      ScreenshotJob.perform_later @site if @site.url?

      redirect_to @site, notice: 'Site was successfully created.'
    else
      render :new
    end
  end

  def update
    respond_to do |format|
      if @site.update(site_params)
        ScreenshotJob.perform_later @site if @site.url?

        format.html { redirect_to @site, notice: 'Site was successfully updated.' }
        format.json { render :show, status: :ok, location: @site }
      else
        format.html { render :edit }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_url, notice: 'Site was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def site_params
      params.require(:site).permit(:name, :url)
    end

    def user_has_site!
      if !@site.account.includes_user? current_user
        render 'shared/error', notice: 'You don\'t own that site', status: :forbidden
      end
    end

    def set_site
      @site = Site.find(params[:id])
    end
end
