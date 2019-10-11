require 'rails_helper'

feature 'Adding links' do
  given(:author_user) { create(:user) }
  given(:question) { create(:question, user: author_user) }
  given(:url_gist) { 'https://gist.github.com/windyeti/6ea00464eb9592b10581097dc2b6c755' }

  context 'Authenticated author', js: true do
    background { sign_in(author_user) }

    scenario 'can added link to his answer' do
      visit question_path(question)


      fill_in 'Body', with: 'New body answer'

      fill_in 'Name', with: 'New link'
      fill_in 'Url', with: url_gist


      click_on 'Create answer'

      within '.answers' do
        expect(page).to have_link 'New link' , href: url_gist
      end
    end
  end
end

