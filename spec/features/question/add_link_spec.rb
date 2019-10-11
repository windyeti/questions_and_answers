require 'rails_helper'

feature 'Adding links' do
  given(:author_user) { create(:user) }
  given(:url_gist) { 'https://gist.github.com/windyeti/6ea00464eb9592b10581097dc2b6c755' }
  context 'Authenticated author' do
    background { sign_in(author_user) }
    scenario 'can added link to his question' do
      visit new_question_path

      fill_in 'Title', with: 'New my title'
      fill_in 'Body', with: 'New my body'

      save_and_open_page

      fill_in 'Name', with: 'New my link'
      fill_in 'Url', with: url_gist


      click_on 'Create question'

      visit questions_path
      click_on 'Show'

      within '.links' do
        expect(page).to have_link 'New my link' , href: url_gist
      end
    end
  end
end
