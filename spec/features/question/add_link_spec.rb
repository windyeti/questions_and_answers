require 'rails_helper'

feature 'Adding links' do
  given(:author_user) { create(:user) }
  given(:url_gist) { 'https://gist.github.com/windyeti/6ea00464eb9592b10581097dc2b6c755' }

  context 'User' do
    background { sign_in(author_user) }

    scenario 'can added link to his question' do
      visit new_question_path

      fill_in 'Title', with: 'New title'
      fill_in 'Body', with: 'New body'

      fill_in 'Name', with: 'New link'
      fill_in 'Url', with: url_gist


      click_on 'Create question'

      within '.links' do
        expect(page).to have_link 'New link' , href: url_gist
      end
    end
  end
end
