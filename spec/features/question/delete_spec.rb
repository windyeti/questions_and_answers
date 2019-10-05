
require 'rails_helper'

feature 'User can delete only his question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_attachment, user: user, title: 'My Title text', body: 'My body text text' ) }

  context 'Authenticated user' do
    background { sign_in(user) }

    scenario 'can delete his question' do
      visit questions_path
      expect(page).to have_content 'My Title text'
      expect(page).to have_content 'My body text text'
      click_on 'Delete'

      expect(page).to_not have_content 'My Title text'
      expect(page).to_not have_content 'My body text text'
      expect(page).to have_content 'Question have been deleted.'
    end

    scenario 'can delete his attachment files from question', js: true do
      visit question_path(question)
      within '.question' do
        expect(page).to have_content 'rails_helper.rb'
        expect(page).to have_content 'spec_helper.rb'
      end

      within "#attachment_id_#{question.files[0].id}" do
        click_on 'Delete'
        expect(page).to_not have_content 'rails_helper.rb'
      end
    end

  end

  context 'Authenticated user not author of question', js: true do
    given(:other_user) { create(:user) }
    background { sign_in(other_user) }

    scenario 'can not delete question' do
      visit questions_path

      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end

    scenario 'can not delete attached files to question' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_selector(:link_or_button, 'Delete')
      end
    end
  end

  context 'Guest' do

    scenario 'can not delete question' do
      visit questions_path

      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end

    scenario 'can not delete attached files to question' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_selector(:link_or_button, 'Delete')
      end
    end
  end
end
