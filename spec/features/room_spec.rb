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
          player = create(:player, village: village, user: user)
          village.room_for_all.posts.create(player: player, content: "はじめまして", day: 0)
          login_as(user)
        end

        scenario 'show', js: true do
          visit villages_path
          click_link '初心者村'

          expect(page).to have_content '初心者村'
          expect(page).to have_content 'プレイヤーの編集'
          expect(page).to have_content '送信'
          expect(page).to have_content 'はじめまして'
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

    context 'when the village is in play' do
      before do
        village = create(:village_with_player, player_num: 10, name: "初心者村")
        village.assign_role
        village.update_to_next_day
        village.update(status: :in_play)
      end

      context 'when the user is player of the village' do
        before do
          player = Village.first.players.villager.first
          player.update(user: user)
          login_as(user)
        end

        scenario 'switch input_area to skill_area', js: true do
          visit villages_path
          click_link '初心者村'

          find('.fa-switch').click
          expect(page).to have_content '投票先'
        end
      end

      context 'when the player is villager' do
        before do
          player = Village.first.players.villager.first
          player.update(user: user)
          login_as(user)
        end

        scenario 'show role and vote form', js: true do
          visit villages_path
          click_link '初心者村'

          find('.fa-switch').click
          expect(page).to have_content '村人'
          expect(page).to have_content '投票先'
        end
      end

      context 'when the player is werewolf' do
        before do
          player = Village.first.players.werewolf.first
          player.update(user: user)
          login_as(user)
        end

        scenario 'show role and attack form', js: true do
          visit villages_path
          click_link '初心者村'

          find('.fa-switch').click
          expect(page).to have_content '人狼'
          expect(page).to have_content '襲撃先'
        end
      end

      context 'when the player is fortune_teller' do
        before do
          player = Village.first.players.fortune_teller.first
          player.update(user: user)
          login_as(user)
        end

        scenario 'show role and divine form', js: true do
          visit villages_path
          click_link '初心者村'

          find('.fa-switch').click
          expect(page).to have_content '占い師'
          expect(page).to have_content '占い先'
        end

        context 'when day of the village is after 2 day' do
          scenario 'show button for fortune teller', js: true do
            Village.first.update(day: 2)
            visit villages_path
            click_link '初心者村'

            find('.fa-switch').click
            expect(page).to have_content '占い結果'
          end
        end
      end

      context 'when the player is psychic' do
        before do
          player = Village.first.players.psychic.first
          player.update(user: user)
          login_as(user)
        end

        context 'when day of the village is after 2 day' do
          scenario 'show button for psychic', js: true do
            Village.first.update(day: 2)
            visit villages_path
            click_link '初心者村'

            find('.fa-switch').click
            expect(page).to have_content '霊媒結果'
          end
        end
      end

      context 'when the player is bodyguard' do
        before do
          player = Village.first.players.bodyguard.first
          player.update(user: user)
          login_as(user)
        end

        scenario 'show role and guard form', js: true do
          visit villages_path
          click_link '初心者村'

          find('.fa-switch').click
          expect(page).to have_content '騎士'
          expect(page).to have_content '護衛先'
        end
      end
    end
  end
end
