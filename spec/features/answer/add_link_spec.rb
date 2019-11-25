require 'rails_helper'

feature 'Adding links' do
  given(:author_user) { create(:user) }
  given(:question) { create(:question, user: author_user) }
  given(:url_google) { 'https://google.ru' }

  context 'Authenticated author', js: true do
    background do
      author_user.confirm
      sign_in(author_user)
    end

    scenario 'can added link to his answer' do
      visit question_path(question)


      fill_in 'Body', with: 'New body answer'

      fill_in 'Name', with: 'New link'
      fill_in 'Url', with: url_google


      click_on 'Create answer'

      within '.answers' do
        expect(page).to have_link 'New link' , href: url_google
      end
    end
  end
end

