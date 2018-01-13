require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { create(:post) }
  it 'has a valid factory' do
    expect(post).to be_valid
  end

  context 'when owner is player' do
    it 'is invalid without player_id' do
      post = build(:post, owner: :player, player: nil)
      expect(post).to be_invalid
    end
  end

  context 'when owner is system' do
    it 'is valid without player_id' do
      post = build(:post, owner: :system, player: nil)
      expect(post).to be_valid
    end
  end

  context 'when the length of the content is 500 characters or less' do
    it 'is saved with all content' do
      post = build(:post, owner: :player, player: nil)
      post.content = "あ" * 500
      post.save
      expect(post.content.length).to eq 500
    end
  end

  context 'when the length of the content is over 500 characters' do
    it 'is saved with content that is compressed to 500 characters' do
      post = build(:post, owner: :player, player: nil)
      post.content = "あ" * 501
      post.save
      expect(post.content.length).to eq 500
    end
  end
end
