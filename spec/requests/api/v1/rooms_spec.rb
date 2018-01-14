require 'rails_helper'
RSpec.describe 'Rooms API', type: :request do
  context 'when owner of the post is player' do
    it 'returns posts' do
      village = create(:village_with_player, player_num: 5)
      player = village.players.first
      post = village.room_for_all.posts.create(player: player, content: 'hello, world', day: 0, owner: :player)
      get "/api/v1/rooms/#{village.room_for_all.id}/posts"

      expect(response).to have_http_status(200)
      first_post = JSON.parse(response.body).first
      expect(first_post['player_id']).to eq post.player.id
      expect(first_post['content']).to eq "<p>#{post.content}</p>"
      expect(first_post['owner']).to eq post.owner
      expect(first_post['created_at']).to eq post.created_at.strftime('%H:%M:%S')
      expect(first_post['image_src']).to eq nil
      expect(first_post['username']).to eq post.player.username
    end
  end

  context 'when owner of the post is system' do
    it 'returns posts' do
      village = create(:village_with_player, player_num: 5)
      post = village.room_for_all.posts.create(content: 'system message', day: 0, owner: :system)
      get "/api/v1/rooms/#{village.room_for_all.id}/posts"

      expect(response).to have_http_status(200)
      first_post = JSON.parse(response.body).first
      expect(first_post['player_id']).to eq 0
      expect(first_post['content']).to eq "<p>#{post.content}</p>"
      expect(first_post['owner']).to eq post.owner
      expect(first_post['created_at']).to eq post.created_at.strftime('%H:%M:%S')
      expect(first_post['image_src']).to eq nil
      expect(first_post['username']).to eq nil
    end
  end
end
