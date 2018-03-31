class NotificationsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_notification, only: %i[show edit update destroy]
  before_action :authorize_notification

  def index
    @notifications = Notification.all.order("created_at DESC")
  end

  def show
  end

  def new
    @notification = Notification.new
  end

  def edit
  end

  def create
    @notification = Notification.new(notification_params)

    if @notification.save
      redirect_to @notification, notice: 'お知らせを作成しました'
    else
      render :new
    end
  end

  def update
    if @notification.update(notification_params)
      redirect_to @notification, notice: 'お知らせを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @notification.destroy
    redirect_to root_url, notice: 'お知らせを削除しました'
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def authorize_notification
    authorize Notification
  end

  def notification_params
    params.require(:notification).permit(:title, :content)
  end
end
