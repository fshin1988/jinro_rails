class Users::AvatarsController < ApplicationController
  before_action :check_params, only: :update

  def edit
  end

  def update
    if current_user.avatar.attach(params[:user][:avatar])
      redirect_to villages_path, notice: "アカウントが更新されました"
    else
      render :edit
    end
  end

  private

  def check_params
    return if params[:user][:avatar].present?
    current_user.errors.add(:base, "プロフィール画像を選択してください")
    render :edit
  end
end
