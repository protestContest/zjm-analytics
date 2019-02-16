class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def current_account
    return nil if !current_user

    if !user_session[:current_account].nil?
      return Account.find(session[:current_account])
    else
      return current_user.all_accounts.min_by(&:created_at)
    end
  end

  def current_account=(account)
    user_session[:current_account] = account.id
  end

  helper_method :current_account
end
