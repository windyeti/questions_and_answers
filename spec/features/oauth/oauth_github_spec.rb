require 'rails_helper'

feature 'User can omniauthenticate' do
  describe 'Github' do
    it 'with valid credentials access to root page' do
      visit new_user_session_path
      expect(page).to have_content("Sign in with GitHub")

      mock_auth_github

      click_on "Sign in with GitHub"
      open_email('mockemail@mail.com')
      current_email.click_link('Confirm my account')
      click_on "Sign in with GitHub"
      expect(page).to have_content("You are log in as mockemail@mail.com")
    end
    it 'with invalid credentials access to root page' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials

      visit new_user_session_path
      expect(page).to have_content("Sign in with GitHub")
      click_on "Sign in with GitHub"
      expect(page).to have_content("You are log in as GUEST")
    end
  end
end
