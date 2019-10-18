require 'rails_helper'

feature 'Award the best answer' do
  given(:user_author_question) { create(:user) }
  given(:user_author_answer) { create(:user) }
  given!(:question) { create(:question, user: user_author_question) }
  given!(:question_with_reward) { create(:question, :with_reward, user: user_author_question) }
  given!(:answer_best) { create(:answer, question: question_with_reward, user: user_author_answer) }

  scenario 'Author of question', js: true do
    sign_in(user_author_question)
    visit question_path(question_with_reward)

    click_on 'Best'

    sign_out(user_author_question)
    sign_in(user_author_answer)

    visit questions_path

    click_on 'My rewards'

    within '.my_rewards' do
      expect(page).to have_content 'My reward for best answer'
      expect(page).to have_css 'img'
    end
  end
end
