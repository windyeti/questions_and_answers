require 'rails_helper'

feature 'Authenticated user can create a comment of answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  before { user.confirm }

  context 'multiple sessions', js: true do
    scenario 'comment appears on another users page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within('.answer') do
          fill_in 'Comment', with: 'My comment'
          click_on 'Save comment'

          expect(page).to have_content 'My comment'
        end
      end

      Capybara.using_session('guest') do
        within('.answer') do
          expect(page).to have_content 'My comment'
        end
      end
    end
  end
end

