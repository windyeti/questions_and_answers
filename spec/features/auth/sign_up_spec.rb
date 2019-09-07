require 'rails_helper'

feature 'User can registered', %q{
  Registration gives the user the ability
  to log in to ask questions and answer
} do
  scenario 'user specifies mail, password and password confirmation' do
    visit new_user_registration_path
    fill_in 'user_email', with: 'user21@test.com'
    fill_in 'user_password', with: '123456'
    fill_in 'user_password_confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')

  end
end
