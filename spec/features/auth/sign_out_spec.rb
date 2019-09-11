require 'rails_helper'

feature 'User can sign out', %q{

} do
  given(:user) { create(:user) }

  scenario 'click on link to sign out' do
  visit new_user_session_path
  fill_in 'Email', with: 'user13@test.com'
  fill_in 'Password', with: '123456'
  click_button 'Log in'

  click_link 'Log out'

  expect(page).to have_content('Signed out successfully.')
  end
end
