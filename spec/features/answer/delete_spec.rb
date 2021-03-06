require 'rails_helper'

feature 'Only authenticate user can delete own answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question ) }
  given!(:answer) { create(:answer, :with_attachment, question: question, user: user, body: 'MY BODY ANSWER') }

  context 'Authenticated user', js: true do
    background do
      user.confirm
      sign_in(user)
    end

    scenario 'can delete own answer' do
      visit question_path(question)
      expect(page).to have_content 'MY BODY ANSWER'
      within '.answer__edit' do
        click_on 'Delete'
      end

      expect(page).to_not have_content 'MY BODY ANSWER'
    end
  end

  context 'Authenticated user not author ' do
    given(:other_user) { create(:user) }
    background do
      other_user.confirm
      sign_in(other_user)
    end

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

