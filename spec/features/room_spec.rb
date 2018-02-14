require 'rails_helper'

feature 'Room', type: :feature do
  context 'when the user is not logged in' do
    context 'when the village is not started' do
      before do
        create(:village_with_player, player_num: 5, name: "初心者村")
      end

      scenario 'sign up' do
        visit villages_path
        click_link '初心者村'

        expect(page).to have_content '初心者村'
      end
    end
  end
end
