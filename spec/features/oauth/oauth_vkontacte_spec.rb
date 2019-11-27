require 'rails_helper'

feature 'User can omniauthenticate' do
  describe 'Vkontakte' do
    it 'with valid credentials access to root page' do
      visit new_user_session_path

      mock_auth_vkontakte

      click_on "Sign in with Vkontakte"

      fill_in 'Email', with: 'mockemail@mail.com'
      click_on 'Save'

      open_email('mockemail@mail.com')
      current_email.click_link('Confirm my account')
      click_on "Sign in with Vkontakte"
      expect(page).to have_content("You are log in as mockemail@mail.com")
    end
    it 'with invalid credentials access to root page' do
      OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials

      visit new_user_session_path
      click_on "Sign in with Vkontakte"
      expect(page).to have_content("You are log in as GUEST")
    end
  end
end
