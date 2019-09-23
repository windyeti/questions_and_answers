require 'rails_helper'

feature 'Only authenticated user can edit answer' do
  context 'Authenticated user' do
      given(:user) { create(:user) }
      given(:question) { create(:question, user: user) }
      given!(:answer) { create(:answer, user: user, question: question) }
      background { sign_in(user) }
    scenario 'with valid data' do
      visit question_path(question)
      click_on 'Edit'

      fill_in 'Your answer', with: 'EDIT ANSWER'
      click_on 'Save'
      save_and_open_page

      sleep(2)
      answer.reload
      expect(answer.body).to eq 'EDIT ANSWER'
    end
    scenario 'with invalid data'
  end

  context 'Not author can not edit answer' do
    scenario 'other user'
    scenario 'guest'
  end
end
