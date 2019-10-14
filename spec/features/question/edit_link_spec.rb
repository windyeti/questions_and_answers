require 'rails_helper'

feature 'Edit links' do
  given(:author_user) { create(:user) }
  given(:question) { create(:question, :with_links, user: author_user) }

  context 'User' do
    background { sign_in(author_user) }

    scenario 'can edit link of his question', js: true do
      visit edit_question_path(question)

      within '#links' do
        expect(page).to_not have_content 'New link'
      end

      within '.nested-fields:first-child' do
        fill_in 'Name', with: 'New link'
        fill_in 'Url', with: 'http://new_url.ru'
      end
        click_on 'Save'

      visit question_path(question)

      within '.links' do
        expect(page).to have_link 'New link' , href: 'http://new_url.ru'
      end
    end
  end
end

