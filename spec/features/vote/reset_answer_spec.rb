require 'rails_helper'

feature 'Reset vote in answer' do
  context 'Authenticated user author answer', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question) }
    given(:answer) { create(:answer, question: question, user: user) }
    given!(:vote) { create(:vote, voteable: answer) }

    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'can not reset' do
      within '.answer' do
        expect(page).to_not have_link("Vote RESET")
        expect(page).to_not have_link("Vote Up")
        expect(page).to_not have_link("Vote Down")
      end
    end
  end

  context 'Guest', js: true do
    given(:question) { create(:question) }
    given(:answer) { create(:answer, question: question) }
    given!(:vote) { create(:vote, voteable: answer) }

    background do
      visit question_path(question)
    end
    scenario 'can not reset' do
      within '.answer' do
        expect(page).to_not have_link("Vote RESET")
        expect(page).to_not have_link("Vote Up")
        expect(page).to_not have_link("Vote Down")
      end
    end
  end

  context 'Authenticated user not author', js: true do
    given(:user_other) { create(:user) }
    given(:question) { create(:question) }
    given(:answer) { create(:answer, question: question) }
    given!(:vote) { create(:vote, user: user_other, voteable: answer) }

    background do
      sign_in(user_other)
      visit question_path(question)
    end
    scenario 'can reset vote and re-vote' do
      within '.answer .vote__balance' do
        expect(find('.vote__value')).to have_content '1'
      end

      within '.answer .vote' do
        click_on "Vote RESET"
      end

      within '.answer .vote__balance' do
        expect(find('.vote__value')).to have_content '0'
      end

      within '.answer .vote' do
        expect(page).to_not have_link("Vote RESET")
        expect(page).to have_link("Vote Up")
        expect(page).to have_link("Vote Down")
      end

      within '.answer .vote' do
        click_on "Vote Down"
      end

      within '.answer .vote__balance' do
        expect(find('.vote__value')).to have_content '-1'
      end
    end
  end
end

