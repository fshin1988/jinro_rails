class PostSerializer < ActiveModel::Serializer
  attributes :player_id, :content, :owner, :created_at, :image_src, :username

  def player_id
    object.player_id || 0
  end

  def created_at
    object.created_at.strftime('%-m/%-d %H:%M:%S')
  end

  def image_src
    object.player&.avatar_image_src
  end

  def username
    object.player&.username
  end
end
