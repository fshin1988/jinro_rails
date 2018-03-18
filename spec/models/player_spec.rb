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
    context 'when the user does not have an avatar' do
      it 'returns nil' do
        expect(player.avatar_image_src).to be_nil
      end
    end

    context 'when the user has an avatar' do
      before do
        player.user.avatar.attach(io: File.open("#{Rails.root}/spec/factories/data/logo.png"), filename: "logo.png")
      end

      it 'returns url of avatar of user' do
        expect(player.avatar_image_src).to match(%r{^http://.*/rails/active_storage/variants/.*/logo\.png$})
      end

      context 'when the player has an avatar' do
        it 'returns url of avatar of player' do
          player.avatar.attach(io: File.open("#{Rails.root}/spec/factories/data/logo.png"), filename: "player.png")
          expect(player.avatar_image_src).to match(%r{^http://.*/rails/active_storage/variants/.*/player\.png$})
        end
      end
    end
  end

  describe '#exit_from_village' do
    it 'updates village_id to 0' do
      user = create(:user)
      village = create(:village_with_player, player_num: 5, status: :not_started)
      player = create(:player, user: user, village: village)
      player.exit_from_village

      expect(player.reload.village_id).to be 0
    end
  end

  it 'is invalid with username which is not unique in the village' do
    village = create(:village)
    create(:player, village: village, username: 'james')
    other_player = build(:player, village: village, username: 'james')
    other_player.valid?

    expect(other_player.errors.messages[:base]).to include('村内で同一ユーザーネームのプレイヤーが存在します')
  end

  context 'if the village has a access password' do
    let(:village) { create(:village, access_password: "12345") }

    it 'is valid with a valid access password' do
      player = build(:player, village: village)
      player.access_password = "12345"

      expect(player).to be_valid
    end

    it 'is invalid with a invalid access password' do
      player = build(:player, village: village)
      player.access_password = "12349"
      player.valid?

      expect(player.errors.messages[:base]).to include('アクセスコードが誤っています')
    end
  end
end
