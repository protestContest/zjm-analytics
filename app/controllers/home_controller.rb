class HomeController < ApplicationController
  def dashboard
    @user = current_user
    @sites = @user.sites
  end
end
