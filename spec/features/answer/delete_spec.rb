require 'rails_helper'

feature 'Only authenticate user can delete own answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user ) }
  given!(:answer) { create(:answer, question: question, user: user, body: 'MY BODY ANSWER') }

  context 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'delete own answer' do
      visit question_path(question)
      click_on 'Delete'

      expect(page).to_not have_content 'MY BODY ANSWER'
    end
  end

  context 'Authenticated user not author ' do
    given(:other_user) { create(:user) }
    background { sign_in(other_user) }

    scenario 'can not delete answer' do
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end

    context 'Guest user' do

      scenario 'can not delete answer' do
        visit question_path(question)

        expect(page).to_not have_selector(:link_or_button, 'Delete')
      end
    end
  end


end

