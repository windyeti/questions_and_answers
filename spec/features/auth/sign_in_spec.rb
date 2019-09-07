require 'rails_helper'

feature 'user can sign in', %q{
  User can sign in
  to have full control own questions and answers
} do
  User.create!(email: 'user4@test.com', password: '123456')

  scenario 'Registered user can sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'user4@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    save_and_open_page

    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'Unregistered user can`t sign in' do
    visit new_user_session_path

    click_on 'Log in'

    expect(page).to have_content('Invalid Email or password.')
  end
end
