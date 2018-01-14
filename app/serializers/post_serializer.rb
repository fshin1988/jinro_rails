class PostSerializer < ActiveModel::Serializer
  attributes :player_id, :content, :owner, :created_at, :image_src, :username

  def player_id
    object.player_id || 0
  end

  def content
    object.content
  end

  def created_at
    object.created_at.strftime('%H:%M:%S')
  end

  def image_src
    if object.player&.user && object.player.user.avatar.attached?
      url_for(object.player.user.avatar.variant(resize: "100x100"))
    else
      nil
    end
  end

  def username
    object.player&.username
  end

  private

  def url_for(image)
    routes = Rails.application.routes
    routes.default_url_options = {host: ENV["HOST_NAME"]}
    routes.url_helpers.url_for(image)
  end
end
