class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if user_signed_in?
      redirect_to villages_path
    else
      redirect_to new_user_session_path
    end
  end
end
