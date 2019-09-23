require 'rails_helper'

feature 'Only author can edit own question' do

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:question) { create(:question, title: 'NOT EDIT TITLE', user: user) }
    background {
      sign_in(user)
      visit questions_path
      click_on 'Edit'
    }

    scenario 'can edit question' do
      fill_in 'Title', with: 'New title'
      click_on 'Save'

      sleep(1)

      question.reload
      expect(question.title).to eq 'New title'
    end

    scenario 'edit question with invalid data' do
      fill_in 'Title', with: ''
      click_on 'Save'

      question.reload
      expect(question.title).to eq 'NOT EDIT TITLE'
    end
  end

  describe 'Can not edit question', js: true do
    given(:user) { create(:user) }
    given!(:question) { create(:question, title: 'NOT EDIT TITLE', user: user) }

    given(:other_user) { create(:user) }
    background {
      sign_in(other_user)
      visit questions_path
    }
    scenario 'other author' do
      expect(page).to_not have_selector(:link_or_button, 'Edit')
    end
    scenario 'guest' do
      expect(page).to_not have_selector(:link_or_button, 'Edit')
    end
  end
end
