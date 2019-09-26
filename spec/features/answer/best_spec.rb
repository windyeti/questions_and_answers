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
      save_and_open_page

      expect(page).to have_css('a.hide_link_best')
    end
  end

end
