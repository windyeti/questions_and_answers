require 'rails_helper'

feature 'Only authenticated user can create answer', %q{

} do
  context 'Create answer' do
    given(:user) { create(:user) }
    given(:question) { user.questions.create(attributes_for(:question)) }

    scenario 'Authenticated user create answer' do
      sign_in(user)

      visit question_path(question)
      fill_in 'Body', with: "My text answer"
      click_on 'Create answer'

      expect(page).to have_content 'Answer have been successfully created.'
      expect(page).to have_content 'My text answer'
      expect(page).to_not have_content "Body can't be blank"
    end

    scenario 'Unauthenticated user can not create a answer' do
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Create answer')
    end
  end
end
