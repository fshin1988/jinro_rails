require 'rails_helper'

feature 'User', type: :feature do
  subject { page }

  context 'when not logged in' do
    scenario 'sign up' do
      expect {
        visit root_path
        click_on 'サインアップ'
        fill_in 'メールアドレス', with: 'test@example.co.jp'
        fill_in 'ユーザーネーム', with: 'test_user'
        fill_in 'パスワード', with: 'test1234'
        fill_in '確認用パスワード', with: 'test1234'
        click_on 'Sign up'
      }.to change(User, :count).by(1)

      expect(current_path).to eq new_user_session_path
    end

    context 'there is a confirmed user' do
      before do
        create(:confirmed_user, email: 'test@example.co.jp', password: 'test1234', password_confirmation: 'test1234')
      end

      scenario 'login' do
        visit root_path
        fill_in 'メールアドレス', with: 'test@example.co.jp'
        fill_in 'パスワード', with: 'test1234'
        click_on 'Log in'

        expect(current_path).to eq villages_path
      end
    end
  end
end
