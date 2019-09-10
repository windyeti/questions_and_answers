require 'rails_helper'

feature 'Only authenticated user can create question and answer', %q{

} do
  context 'Create question' do
    given(:user) { create(:user) }

    scenario 'Authenticated user create question' do
      sign_in(user)

      visit questions_path
      click_on 'Ask'

      expect(page).to have_content 'Create question'
    end

    scenario 'Unauthenticated user does not create a question' do
      visit questions_path
      click_on 'Ask'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'Create answer' do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    scenario 'Authenticated user create answer' do
      sign_in(user)

      visit question_path(question)
      fill_in 'answer_body', with: "My text answer"
      click_on 'Create answer'

      expect(page).to have_content 'Answer have been successfully created.'
      expect(page).to have_content 'My text answer'
    end

    scenario 'Unauthenticated user can not create a answer' do
      visit question_path(question)
      fill_in 'answer_body', with: "My text answer"
      click_on 'Create answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
