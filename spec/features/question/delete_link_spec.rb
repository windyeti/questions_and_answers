
require 'rails_helper'

feature 'Delete link', js: true do
  given(:author_user) { create(:user) }
  given(:question) { create(:question, :with_links, user: author_user) }

  context 'Authenticated user author' do
    background { sign_in(author_user) }

    scenario 'can delete link of his question' do
      visit question_path(question)
      expect(page).to have_link 'Rbk' , href: 'https://rbk.ru'

      within '.question .links li:last-child' do
      save_and_open_page
        click_on 'Delete'
      end

      expect(page).to_not have_link 'Rbk' , href: 'https://rbk.ru'
    end
  end

  context 'Authenticated user not author' do
    given(:other_user) { create(:user) }
    background { sign_in(other_user) }

    scenario 'cannot delete link of question' do
      visit question_path(question)
      within '.links' do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  context 'Guest' do
    given(:other_user) { create(:user) }
    background { sign_in(other_user) }

    scenario 'cannot delete link of question' do
      visit question_path(question)
      within '.links' do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

end
