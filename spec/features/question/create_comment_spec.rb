require 'rails_helper'

feature 'Authenticated user can create a comment of question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

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
        within('.question') do
          fill_in 'Comment', with: 'My comment'
          click_on 'Save comment'

          expect(page).to have_content 'My comment'
        end
      end

      Capybara.using_session('guest') do
        within('.question') do
          expect(page).to have_content 'My comment'
        end
      end
    end
  end
end

