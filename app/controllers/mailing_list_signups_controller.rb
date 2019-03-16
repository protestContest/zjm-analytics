class MailingListSignupsController < ApplicationController
  skip_before_action :authenticate_user!, only: :create

  def create
    signup = MailingListSignup.new(mailing_list_signup_params)
    signup.save
    flash[:thanks] = "Thanks! We'll email you when we're ready"
    redirect_to root_url
  end

  private

    def mailing_list_signup_params
      params.require(:mailing_list_signup).permit(:email)
    end
end
