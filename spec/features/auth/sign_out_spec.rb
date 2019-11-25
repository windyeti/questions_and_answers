require 'rails_helper'

feature 'Authenticated user can log out' do
  given(:user) { create(:user, email: 'user13@test.com', password: '123456') }
  background {
    # user.confirm
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  }

  scenario 'click on link to Log out' do
  expect(page).to have_content('You are log in as user13@test.com')

  click_link 'Log out'

  expect(page).to have_content('Signed out successfully.')
  end
end
