require 'rails_helper'

feature 'User can delete only his question and answer', %q{

} do
  given(:user) { create(:user) }
  given!(:question) { user.questions.create( attributes_for(:question) ) }

  context 'Question' do
    scenario 'Authenticated user delete question' do
      sign_in(user)
      visit questions_path
      click_on 'Delete'

      expect(page).to have_content 'Question have been delete.'
    end

    scenario 'Unauthenticated user does not delete question' do
      visit questions_path
      click_on 'Delete'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'Answer' do
    given!(:answer) { question.answers.create(attributes_for(:answer)) }

    scenario 'Authenticated user delete answer' do
      sign_in(user)
      visit questions_path
      click_on 'Show'
      click_on 'Delete'

      expect(page).to have_content 'Answer have been delete.'
    end

    scenario 'Unauthenticated user does not delete answer' do
      visit questions_path
      click_on 'Show'
      click_on 'Delete'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

end
