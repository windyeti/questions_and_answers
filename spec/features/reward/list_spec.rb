require 'rails_helper'

feature 'Show rewards', %q{
  To award best answer
} do
    given(:user_author_question) { create(:user) }
    given(:user_author_answer) { create(:user) }
    given!(:question) { create(:question, user: user_author_question) }
    given!(:reward) { create(:reward, :with_picture, user: user_author_answer, question: question) }

  context 'Authenticated user' do
    background { sign_in(user_author_answer) }

    scenario 'can look his rewards', js: true do
      visit questions_path

      click_on 'My rewards'

      within '.my_rewards' do
        expect(page).to have_content 'My reward for best answer'
        expect(page).to have_css 'img'
      end
    end
  end

  context 'Authenticated user not awarded' do
    background { sign_in(user_author_question) }

    scenario 'can look his rewards', js: true do
      visit questions_path

      click_on 'My rewards'

      expect(page).to_not have_content 'My reward for best answer'
    end
  end

  context 'Guest' do

    scenario 'can look his rewards', js: true do
      visit questions_path

      expect(page).to_not have_content 'My rewards'
    end
  end
end
