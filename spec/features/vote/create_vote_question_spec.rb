require 'rails_helper'

feature 'Voting' do
  context 'Authenticated user author question', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }

    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'can not voted' do
      within '.question' do
        expect(page).to_not have_css(".vote")
      end
    end
  end

  context 'Guest', js: true do
    given(:question) { create(:question) }

    background do
      visit question_path(question)
    end
    scenario 'can not voted' do
      within '.question' do
        expect(page).to_not have_css(".vote")
      end
    end
  end

  context 'Authenticated user not author', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'can voted' do
      within '.vote' do
        click_on "Vote Up"
      end
      expect(page).to have_content("Vote RESET")
    end
  end
end
