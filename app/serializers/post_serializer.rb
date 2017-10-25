class PostSerializer < ActiveModel::Serializer
  attributes :id, :player_id, :content, :created_at
end
