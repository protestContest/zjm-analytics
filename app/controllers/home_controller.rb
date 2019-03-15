class HomeController < ApplicationController
  def dashboard
    @user = current_user
    @sites = current_account.sites
  end
end
