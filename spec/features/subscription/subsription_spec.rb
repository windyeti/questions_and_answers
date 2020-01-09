require 'rails_helper'

feature 'User can subscribe for question', js: true do
  context 'Authorized' do
    given(:question) { create(:question) }
    given(:user) { create(:user) }
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Subscribe' do
      within ('.question__subscription') do
        expect(page).to have_content 'Subscribe'
        expect(page).to_not have_content 'Unsubscribe'
      end
    end

    scenario 'Unsubscribe' do
      click_on 'Subscribe'
      sleep 1
      within ('.question__subscription') do
        expect(page).to_not have_content 'Subscribe'
        expect(page).to have_content 'Unsubscribe'
      end
      click_on 'Unsubscribe'
      within ('.question__subscription') do
        expect(page).to have_content 'Subscribe'
        expect(page).to_not have_content 'Unsubscribe'
      end
    end
  end

  context 'Author' do
    given(:author) { create(:user) }
    given(:question) { create(:question, user: author) }
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'can Unsubscribe' do
      click_on 'Unsubscribe'
      within ('.question__subscription') do
        expect(page).to have_content 'Subscribe'
        expect(page).to_not have_content 'Unsubscribe'
      end
    end
  end

  context 'Guest' do
    given(:question) { create(:question) }
    background do
      visit question_path(question)
    end

    scenario 'cannot Subscribe' do
      expect(page).to_not have_content 'Subscribe'
      expect(page).to_not have_content 'Unsubscribe'
    end
  end

end

