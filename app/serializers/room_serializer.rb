class RoomSerializer < ActiveModel::Serializer
  include RoomsHelper
  attributes :title

  def title
    room_title(object.village)
  end
end
