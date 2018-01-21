require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:player) { create(:player) }
  it 'has a valid factory' do
    expect(player).to be_valid
  end

  describe '#human?' do
    context 'when player is human' do
      it 'returns true' do
        player = create(:player, role: 'villager')
        expect(player.human?).to be_truthy
      end
    end

    context 'when player is werewolf' do
      it 'returns false' do
        player = create(:player, role: 'werewolf')
        expect(player.human?).to be_falsey
      end
    end
  end

  describe '#avatar_image_src' do
    context 'when a user does not have an avatar' do
      it 'returns nil' do
        expect(player.avatar_image_src).to be_nil
      end
    end

    context 'when a user has a avatar' do
      it 'returns url of avatar' do
        player.user.avatar.attach(io: File.open("#{Rails.root}/spec/factories/data/logo.png"), filename: "logo.png")
        expect(player.avatar_image_src =~ %r{^http://.*/rails/active_storage/variants/.*/logo\.png$}).not_to be_nil
      end
    end
  end
end
