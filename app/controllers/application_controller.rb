class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def current_account
    return nil if !current_user

    if !user_session['current_account'].nil?
      account = Account.find(user_session['current_account'])
      account ||= current_user.all_accounts.min_by(&:created_at)
    else
      account = current_user.all_accounts.min_by(&:created_at)
    end

    if account.nil?
      account = current_user.owned_accounts.build(name: 'Personal')
      account.save
    end

    return account
  end

  def switch_to_account account
    user_session[:current_account] = account.id
  end

  helper_method :current_account
end
