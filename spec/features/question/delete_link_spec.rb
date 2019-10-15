
require 'rails_helper'

feature 'Delete link', js: true do
  given(:author_user) { create(:user) }
  given(:question) { create(:question, :with_links, user: author_user) }

  context 'Authenticated user author' do
    background { sign_in(author_user) }

    scenario 'can delete link of his question' do
      visit question_path(question)
      expect(page.all('li')[0]).to have_link 'Gist' , href: 'https://gist.github.com/windyeti/6ea00464eb9592b10581097dc2b6c755'

      within '.question .links li:first-child' do
        click_on 'Delete'
      end

      expect(page.all('li')[0]).to_not have_link 'Gist' , href: 'https://gist.github.com/windyeti/6ea00464eb9592b10581097dc2b6c755'
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