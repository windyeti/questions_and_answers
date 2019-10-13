require 'rails_helper'

feature 'Add links in exists question' do
  given(:author_user) { create(:user) }
  given(:question) { create(:question, user: author_user) }

  context 'User' do
    background { sign_in(author_user) }

    scenario 'can add link in exists his question', js: true do
      visit question_path(question)

      expect(page).to_not have_link 'New link' , href: 'http://new_url.ru'

      visit edit_question_path(question)

      fill_in 'Name', with: 'New link'
      fill_in 'Url', with: 'http://new_url.ru'

      click_on 'Save'

      visit question_path(question)

      expect(page).to have_link 'New link' , href: 'http://new_url.ru'
    end
  end
end

