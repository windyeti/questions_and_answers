require 'rails_helper'

feature 'Only authenticated user can edit answer' do
      given(:user) { create(:user) }
      given(:question) { create(:question) }
      given!(:answer) { create(:answer, body: 'My body answer', user: user, question: question) }

  context 'Authenticated user', js: true do
      background { sign_in(user) }
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
  end

  context 'Authenticated not author', js: true do
    given(:other_user) { create(:user) }
    background { sign_in(other_user) }

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
