class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def welcome
    if user_signed_in?
      redirect_to villages_path
    else
      render 'welcome'
    end
  end
end
