require 'rails_helper'

feature 'Only author can edit own question' do

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:question) { create(:question, title: 'NOT EDIT TITLE', user: user) }
    background {
      sign_in(user)
      visit questions_path
    }

    scenario 'can edit question' do
      click_on 'Edit'

      fill_in 'Title', with: 'New title'
      click_on 'Save'

      sleep(1)

      question.reload
      expect(question.title).to eq 'New title'
    end

    scenario 'edit question with invalid data' do
      click_on 'Edit'

      fill_in 'Title', with: ''
      click_on 'Save'

      question.reload
      expect(question.title).to eq 'NOT EDIT TITLE'
      expect(page).to have_content("Title can't be blank")
    end

    scenario 'can add files' do
      click_on 'Show'

      within 'div.attached' do
        expect(page).to_not have_content 'rails_helper.rb'
        expect(page).to_not have_content 'spec_helper.rb'
      end
      save_and_open_page
      visit questions_path
      click_on 'Edit'


      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'

      visit questions_path
      click_on 'Show'

      within 'div.attached' do
        expect(page).to have_content 'rails_helper.rb'
        expect(page).to have_content 'spec_helper.rb'
      end
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
