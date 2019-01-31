class SitesController < ApplicationController
  before_action :set_site, only: [:show, :edit, :update, :destroy]

  def index
    @user = current_user
    @sites = @user.sites
  end

  def show
  end

  def new
    @site = Site.new
  end

  def edit
  end

  def create
    @site = current_user.sites.build(site_params)

    if @site.save
      redirect_to @site, notice: 'Site was successfully created.'
    else
      render :new
    end
  end

  def update
    respond_to do |format|
      if @site.update(site_params)
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
      format.html { redirect_to sites_url, notice: 'Site was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def site_params
      params.require(:site).permit(:name)
    end

    def set_site
      @site = Site.find(params[:id])
    end
end
