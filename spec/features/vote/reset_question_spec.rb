require 'rails_helper'

feature 'Reset vote' do
  context 'Authenticated user author question', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }

    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'can not vote' do
      within '.question' do
        expect(page).to_not have_link("Vote RESET")
        expect(page).to_not have_link("Vote Up")
        expect(page).to_not have_link("Vote Down")
      end
    end
  end

  context 'Guest', js: true do
    given(:question) { create(:question) }

    background do
      visit question_path(question)
    end
    scenario 'can not vote' do
      within '.question' do
        expect(page).to_not have_link("Vote RESET")
        expect(page).to_not have_link("Vote Up")
        expect(page).to_not have_link("Vote Down")
      end
    end
  end

  context 'Authenticated user not author', js: true do
    given(:user_other) { create(:user) }
    given(:question) { create(:question) }
    given!(:vote) { create(:vote, user: user_other, voteable: question) }

    background do
      sign_in(user_other)
      visit question_path(question)
    end
    scenario 'can reset vote' do
      within '.question .vote' do
        click_on "Vote RESET"
      end

      within '.question .vote' do
        expect(page).to_not have_link("Vote RESET")
        expect(page).to have_link("Vote Up")
        expect(page).to have_link("Vote Down")
      end
    end
  end
end
