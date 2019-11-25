require 'rails_helper'

feature 'Registration user', %q{
  Registration gives the user the ability
  to log in to ask questions and answer
} do
  context 'User entry valid data' do
    background do
      user_sign_up_with_data
      open_email('user21@test.com')
      current_email.click_link 'Confirm my account'
    end
    scenario 'User sign up' do
      expect(page).to have_content('Your email address has been successfully confirmed.')
    end

    scenario 'User re-sign up with the same data' do
      click_on 'Log out'
      user_sign_up_with_data

      expect(page).to have_content('Email has already been taken')
    end
  end

  scenario 'User entry invalid data' do
    visit new_user_registration_path
    click_on 'Sign up'

    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")

  end
end


