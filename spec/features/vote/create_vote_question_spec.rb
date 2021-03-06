require 'rails_helper'

feature 'Voting' do
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
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'can vote up' do
      within '.question .vote' do
        click_on "Vote Up"
      end
      expect(page).to have_link("Vote RESET")
      expect(page).to_not have_link("Vote Up")
      expect(page).to_not have_link("Vote Down")
    end

    scenario 'can vote down' do
      within '.question .vote' do
        click_on "Vote Down"
      end
      expect(page).to have_link("Vote RESET")
      expect(page).to_not have_link("Vote Up")
      expect(page).to_not have_link("Vote Down")
    end
  end
end
