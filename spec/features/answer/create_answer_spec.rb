require 'rails_helper'

feature 'User can create an answer on the page question', %q{
  When user visit page of question
  then can create answer
} do
  given(:user) { create(:user) }

  context 'Authenticated user create answer', js: true do
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
    end

    scenario 'with invalid body field' do
      click_on 'Create answer'

      expect(page).to have_content("Body can't be blank")
    end

    scenario 'with attachment file' do
      fill_in 'Body', with: 'My text answer'

      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Create answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'Guest user can not create answer', js: true do
    given(:question) { create(:question, user: user) }

    scenario 'with valid body field' do
      visit question_path(question)

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)

      expect(page).to_not have_selector(:link_or_button, 'Create answer')
    end
  end
end
