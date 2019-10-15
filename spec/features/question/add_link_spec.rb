require 'rails_helper'

feature 'Adding links' do
  given(:author_user) { create(:user) }
  given(:url_google) { 'https://google.ru' }

  context 'User' do
    background { sign_in(author_user) }

    scenario 'can added link to his question' do
      visit new_question_path

      fill_in 'Title', with: 'New title'
      fill_in 'Body', with: 'New body'

      fill_in 'Name', with: 'New link'
      fill_in 'Url', with: url_google


      click_on 'Create question'

      within '.links' do
        expect(page).to have_link 'New link' , href: url_google
      end
    end
  end
end
