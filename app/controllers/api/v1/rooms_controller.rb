class Api::V1::RoomsController < Api::V1::ApiController
  skip_before_action :authenticate_user!, only: %i[posts]
  before_action :set_room

  def posts
    render json: @room.posts.order(created_at: :asc).includes(player: {user: :avatar_attachment}),
           each_serializer: PostSerializer
  end

  private

  def set_room
    @room = Room.find(params[:id])
    authorize @room
  end
end
