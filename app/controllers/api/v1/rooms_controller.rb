class Api::V1::RoomsController < Api::V1::ApiController
  skip_before_action :authenticate_user!, only: %i[posts all_posts]
  before_action :set_room

  def speak
    player = @room.village.player_from_user(current_user)
    if @room.posts.create!(player: player, content: speak_params[:message], day: @room.village.day)
      head :ok
    else
      head :bad_request
    end
  end

  def posts
    render json: latest_20_posts(@room),
           each_serializer: PostSerializer
  end

  def all_posts
    render json: @room.posts.order(created_at: :asc).includes(player: {avatar_attachment: :blob}),
           each_serializer: PostSerializer
  end

  private

  def set_room
    @room = Room.find(params[:id])
    authorize @room
  end

  def latest_20_posts(room)
    room.posts.order(created_at: :desc).includes(player: {avatar_attachment: :blob}).limit(20).reverse
  end

  def speak_params
    params.require(:room).permit(:message)
  end
end
