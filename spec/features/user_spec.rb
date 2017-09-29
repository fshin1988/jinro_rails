require 'rails_helper'

feature 'User', type: :feature do
  subject { page }

  context 'when not logged in' do
    scenario 'sign up', js: true do
      expect {
        visit root_path
        click_on 'サインアップ'
        fill_in 'Email', with: 'test@example.co.jp'
        fill_in 'Username', with: 'test_user'
        fill_in 'Password', with: 'test1234'
        fill_in 'Password confirmation', with: 'test1234'
        click_on 'Sign up'
      }.to change(User, :count).by(1)
      expect(current_path).to eq root_path
    end
  end
end
