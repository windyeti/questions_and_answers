require 'rails_helper'

feature 'Only author can select best of question' do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
    given!(:answer) { create(:answer, question: question) }

  context 'Authenticated author', js: true do
    background { sign_in(user) }
    scenario 'select best answer' do
      visit question_path(question)
      click_on 'Best'

      sleep(1)

      answer.reload
      expect(answer.best).to be true
    end

  end

  context 'Authenticated user not author ' do
  given(:other_user) { create(:user) }
  background { sign_in(other_user) }

    scenario 'can not select best answer' do
      visit question_path(question)

      expect(page).to have_css('a.hide_link_best')
    end
  end

  context 'Guest user not author ' do
    scenario 'can not select best answer' do
      visit question_path(question)

      expect(page).to have_css('a.hide_link_best')
    end
  end

    context 'Only one answer should be best', js: true do
      background { sign_in(user) }
      given!(:answer_start_best) { create(:answer, question: question, body: 'The best answer', best: true) }

      scenario 'Set other answer as best' do
        visit question_path(question)

        click_on 'Best'

        sleep(1)

        answer.reload
        answer_start_best.reload

        sleep(3)

        expect(answer.best).to be true
        expect(answer_start_best.best).to be false
      end
    end

    context 'Must be the first best answer on the list', js: true do
      background { sign_in(user) }
      given!(:answer_start_best) { create(:answer, question: question, body: 'The best answer', best: true) }

      scenario 'checking the number of best answer' do
        visit question_path(question)

        within '.answer:first-child' do
          expect(page).to have_content'The best answer'
        end
      end
    end

end
