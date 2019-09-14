require 'rails_helper'

feature 'User can create an answer on the page question', %q{
  When user visit page of question
  then can create answer
} do
  context 'Authenticated user create answer' do
    given(:user) { create(:user) }
    background { sign_in(user) }

    given(:question) { create(:question, user: user) }

    background {

      visit question_path(question)

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    }

    scenario 'with valid body field' do
      fill_in 'Body', with: 'My text answer'

      click_on 'Create answer'

      expect(page).to have_content('My text answer')
      expect(page).to_not have_content("Body can't be blank")
    end

    scenario 'with invalid body field' do
      click_on 'Create answer'

      expect(page).to have_content("Body can't be blank")
    end
  end

  context 'Unauthenticated user cannot create answer' do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }

    scenario 'with valid body field' do
      visit question_path(question)

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)

      expect(page).to_not have_selector(:link_or_button, 'Create answer')
    end
  end
end
