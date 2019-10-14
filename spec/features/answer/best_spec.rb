require 'rails_helper'

feature 'Only author can choose best question' do
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

  context 'The best answer already exists', js: true do
    background { sign_in(user) }
    given!(:answer_start_best) { create(:answer, question: question, body: 'The best answer', best: true) }

    scenario 'The best answer should be first' do
      visit question_path(question)

      within '.answers' do
        expect(page.all('.answer')[0]).to have_content 'The best answer'
        expect(page.all('.answer')[0]['class']).to eq 'answer best'
        expect(page.all('.answer')[1]['class']).to eq 'answer'
      end

      click_on 'Best'

      sleep 1

      within '.answers' do
        expect(page.all('.answer')[0]).to_not have_content'The best answer'
        expect(page.all('.answer')[0]['class']).to eq 'answer best'
        expect(page.all('.answer')[1]['class']).to eq 'answer'
      end
    end

    scenario 'Only one answer should be best' do
      visit question_path(question)

      within '.answers' do
        expect(page.all('.best').length).to eq 1
      end
    end
  end

  context 'Must be the first best answer on the list'
end
