require 'rails_helper'

feature 'User create reward', %q{
  To award best answer
} do
  context 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'user ask a question with valid fields' do

      fill_in "Title", with: "My text title"
      fill_in "Body", with: "My text text text body"

      within '.reward' do
        fill_in "Name", with: "My name reward"
        attach_file 'Picture', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on "Create question"

      within '.reward' do
        expect(page).to have_content"My name reward"
        expect(page).to have_css'img'
      end
    end
  end
end
