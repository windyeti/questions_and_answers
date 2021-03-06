require 'rails_helper'

feature 'Only authenticated user can edit answer' do
      given(:user) { create(:user) }
      given(:question) { create(:question) }
      given!(:answer) { create(:answer, body: 'My body answer', user: user, question: question) }

  context 'Authenticated user', js: true do
      background do
        user.confirm
        sign_in(user)
      end

    scenario 'with valid data' do
      visit question_path(question)
      click_on 'Edit'

      fill_in 'Your answer', with: 'EDIT ANSWER'
      click_on 'Save'

      sleep(1)
      answer.reload
      expect(answer.body).to eq 'EDIT ANSWER'
    end

    scenario 'with invalid data' do
      visit question_path(question)
      click_on 'Edit'

      fill_in 'Your answer', with: ''
      click_on 'Save'

      sleep(1)
      answer.reload
      expect(answer.body).to eq 'My body answer'
      expect(page).to have_content("Body can't be blank")
    end

    scenario 'can edit answer with addition of files' do
      visit question_path(question)

      within '.answer__attachment' do
        expect(page).to_not have_content 'rails_helper.rb'
        expect(page).to_not have_content 'spec_helper.rb'
      end
      visit question_path(question)
      click_on 'Edit'

      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'

      sleep(3)

      visit question_path(question)

      sleep(3)

      within '.answer__attachment' do
        expect(page).to have_content 'rails_helper.rb'
        expect(page).to have_content 'spec_helper.rb'
      end
    end
  end

  context 'Authenticated not author', js: true do
    given(:other_user) { create(:user) }
    background do
      other_user.confirm
      sign_in(other_user)
    end

    scenario 'can not edit answer' do
      visit question_path(question)
      expect(page).to_not have_selector(:link_or_button, 'Edit')
    end
  end

  context 'Unauthenticated user', js: true do
    scenario 'can not edit answer' do
      visit question_path(question)
      expect(page).to_not have_selector(:link_or_button, 'Edit')
    end
  end
end
