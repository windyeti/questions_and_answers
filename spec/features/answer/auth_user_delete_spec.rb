require 'rails_helper'

feature 'User can delete only his answer', %q{

} do
  given(:user) { create(:user) }
  given!(:question) { user.questions.create( title: 'My Title text', body: 'My body text text' ) }

  context 'Answer' do
    given!(:answer) { create(:answer, question: question, user: user) }

    scenario 'Authenticated user delete his answer' do
      sign_in(user)
      visit questions_path
      click_on 'Show'

      click_on 'Delete'

      expect(page).to_not have_content 'My body answer text'
      expect(page).to have_content 'Answer have been deleted.'
    end

    given(:user2) { create(:user) }

    scenario 'Authenticated user can not delete answer that created another user' do
      sign_in(user2)
      visit questions_path
      click_on 'Show'

      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end

    scenario 'Unauthenticated user does not delete answer' do
      visit questions_path
      click_on 'Show'

      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end
  end

end

