require 'rails_helper'

feature 'Only author can edit own question' do

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:question) { create(:question, user: user) }
    background { sign_in(user) }

    scenario 'can edit question' do
      visit questions_path
      click_on 'Edit'

      fill_in 'Title', with: 'New title'
      click_on 'Save'

      sleep(1)

      question.reload
      save_and_open_page
      expect(question.title).to have_content 'New title'
    end

    scenario 'not author cannot edit question'
    scenario 'edit question with invalid data'
  end

  describe 'Unauthenticated user can not edit question'
end
