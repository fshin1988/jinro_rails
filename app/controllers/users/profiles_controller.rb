class Users::ProfilesController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  before_action :set_profile, only: %i[show edit update]

  def show
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to users_profile_path(@profile), notice: "#{@profile.user.username} のコメントを更新しました"
    else
      render :edit
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
    authorize @profile
  end

  def profile_params
    params.require(:profile).permit(:comment)
  end
end
