class PostSerializer < ActiveModel::Serializer
  attributes :player_id, :content, :owner, :created_at, :image_src, :username

  def content
    object.content
  end

  def created_at
    object.created_at.strftime('%H:%M:%S')
  end

  def image_src
    if object.player&.user && object.player.user.avatar.attached?
      object.player.user.avatar.variant(resize: "100x100").service_url
    else
      nil
    end
  end

  def username
    object.player&.username
  end
end
