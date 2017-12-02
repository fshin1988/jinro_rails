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
end
