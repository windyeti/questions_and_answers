
require 'rails_helper'

feature 'Delete links' do
  given(:author_user) { create(:user) }
  given(:question) { create(:question, :with_links, user: author_user) }

  context 'User' do
    background { sign_in(author_user) }

    scenario 'can delete link to his question' do
      visit edit_question_path(question)

      within '.nested-fields:first-child' do
        click_on 'remove link'
      end

      within '#links' do
        expect(page).to_not have_link 'Gist' , href: 'https://gist.github.com/windyeti/6ea00464eb9592b10581097dc2b6c755'
      end
    end
  end
end
