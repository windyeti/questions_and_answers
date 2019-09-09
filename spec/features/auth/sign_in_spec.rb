require 'rails_helper'

feature 'user can sign in', %q{
  User can sign in
  to have full control own questions and answers
} do
  given(:user) { create(:user) }

  scenario 'Registered user can sign in' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'Unregistered user can`t sign in' do
    visit new_user_session_path

    click_on 'Log in'

    expect(page).to have_content('Invalid Email or password.')
  end
end
