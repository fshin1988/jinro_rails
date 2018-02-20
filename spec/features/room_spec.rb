require 'rails_helper'

feature 'Room', type: :feature do
  let(:user) { create(:confirmed_user) }

  context 'when the user is not logged in' do
    context 'when the village is not started' do
      before do
        create(:village_with_player, player_num: 5, name: "初心者村")
      end

      scenario 'show' do
        visit villages_path
        click_link '初心者村'

        expect(page).to have_content '初心者村'
        expect(page).to_not have_content '送信'
      end
    end
  end

  context 'when the user is logged in' do
    context 'when the village is not started' do
      context 'when the user is player of the village' do
        before do
          village = create(:village_with_player, player_num: 5, name: "初心者村")
          village.update(player_num: 6)
          create(:player, village: village, user: user)
          login_as(user)
        end

        scenario 'show' do
          visit villages_path
          click_link '初心者村'

          expect(page).to have_content '初心者村'
          expect(page).to have_content 'プレイヤーの編集'
          expect(page).to have_content '送信'
        end

        scenario 'collapse input area', js: true do
          visit villages_path
          click_link '初心者村'

          find('.switch-input').click
          expect(page).to_not have_content '送信'
        end
      end

      context 'when the user is creator of the village' do
        before do
          create(:village_with_player, player_num: 5, name: "初心者村", user: user)
          login_as(user)
        end

        scenario 'show' do
          visit villages_path
          click_link '初心者村'

          expect(page).to have_content '初心者村'
          expect(page).to have_content 'ゲーム開始'
          expect(page).to have_content '村の編集'
          expect(page).to have_content 'プレイヤーのキック'
        end
      end
    end
  end
end
