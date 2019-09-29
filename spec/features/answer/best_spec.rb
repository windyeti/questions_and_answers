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

      expect(page).to have_css('.answer.best')
    end

  end

  context 'Authenticated user not author ', js: true do
    given(:other_user) { create(:user) }
    background { sign_in(other_user) }

    scenario 'can not select best answer' do
      visit question_path(question)

      expect(page).to_not have_content('Best')
    end
  end

  context 'Guest user not author ', js: true do
    scenario 'can not select best answer' do
      visit question_path(question)

      expect(page).to_not have_selector('textarea')
      expect(page).to_not have_content('Best')
    end
  end

  context 'Only one answer should be best', js: true do
    background { sign_in(user) }
    given!(:answer_start_best) { create(:answer, question: question, body: 'The best answer', best: true) }

    scenario 'Set other answer as best' do
      visit question_path(question)

      within '.answers' do
        expect(find('.answer:first-child')['class']).to eq 'answer best'
        expect(find('.answer:last-child')['class']).to eq 'answer'
      end

      within '.answer:first-child' do
        expect(page).to have_content'The best answer'
      end

      click_on 'Best'

      within '.answer:first-child' do
        expect(page).to_not have_content'The best answer'
      end
      within '.answers' do
        expect(find('.answer:first-child')['class']).to eq 'answer best'
        expect(find('.answer:last-child')['class']).to eq 'answer'
      end
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

    # context 'The order of answers in the list on the question page' do
    #   background { sign_in(user) }
    #   given!(:answer) { create(:answer, question: question, body: 'MY BODY BEST ANSWER 1', best: true) }
    #   given!(:answers) { create_list(:answer, question: question) }
    #   given!(:answer) { create(:answer, question: question, body: 'MY BODY BEST ANSWER 2', best: true) }
    #   scenario 'best is first' do
    #
    #   end
    # end
end
