require 'rails_helper'

feature 'Voting' do
  context 'Authenticated user author answer', js: true do
    given(:user_author) { create(:user) }
    given(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question, user: user_author) }

    background do
      sign_in(user_author)
      visit question_path(question)
    end
    scenario 'can not voted' do

      within '.answer' do
        expect(page).to_not have_css(".vote__up")
      end
    end
  end

  context 'Guest', js: true do
    given(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }

    background do
      visit question_path(question)
    end
    scenario 'can not voted' do
      within '.answer' do
        expect(page).to_not have_css(".vote__up")
      end
    end
  end

  context 'Authenticated user not author', js: true do
    given(:user_other) { create(:user) }
    given(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }

    background do
      sign_in(user_other)
      visit question_path(question)
    end
    scenario 'can voted' do
      within '.answer .vote' do
        click_on "Vote Up"
      end
      expect(page).to have_content("Vote RESET")
    end
  end
end
