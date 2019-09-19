
require 'rails_helper'

feature 'User can delete only his question' do
  given(:user) { create(:user) }
  given!(:question) { user.questions.create( title: 'My Title text', body: 'My body text text' ) }

  context 'Question' do
    scenario 'Authenticated user delete his question' do
      sign_in(user)
      visit questions_path
      expect(page).to have_content 'My Title text'
      expect(page).to have_content 'My body text text'

      click_on 'Delete'

      expect(page).to_not have_content 'My Title text'
      expect(page).to_not have_content 'My body text text'
      expect(page).to have_content 'Question have been delete.'
    end

    given(:user2) { create(:user) }

    scenario 'Authenticated user can not delete question that created another user' do
      sign_in(user2)
      visit questions_path

      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end

    scenario 'Unauthenticated user does not delete question' do
      visit questions_path

      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end
  end
end
