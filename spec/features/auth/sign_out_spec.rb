require 'rails_helper'

feature 'Authenticated user can log out', %q{

} do
  background {
    visit new_user_session_path
    fill_in 'Email', with: 'user13@test.com'
    fill_in 'Password', with: '123456'
    click_button 'Log in'
  }

  scenario 'click on link to Log out' do
  click_link 'Log out'

  expect(page).to have_content('Signed out successfully.')
  end
end
