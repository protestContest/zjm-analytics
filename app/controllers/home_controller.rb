class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: :landing_page

  def dashboard
    @user = current_user
    @sites = current_account.sites
  end

  def landing_page
    render :action => "landing_page", :layout => "blank"
  end
end
