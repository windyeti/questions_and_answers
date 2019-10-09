require 'rails_helper'

feature 'User create question', %q{
  To resolve issue
} do
  context 'Authenticated user' do
    given(:user) { create(:user) }

    background {
      sign_in(user)

      visit questions_path
      click_on 'Ask'

      expect(page).to have_content("Create question")
    }
    scenario 'user ask a question with valid fields' do
      fill_in "Title", with: "My text title"
      fill_in "Body", with: "My text text text body"
      click_on "Create question"

      expect(page).to have_content("My text title")
      expect(page).to have_content("My text text text body")
    end

    scenario 'user ask a question with invalid title field' do
      fill_in "Body", with: "My text text text body"
      click_on "Create question"

      expect(page).to have_content("Title can't be blank")
    end

    scenario 'user ask a question with invalid body field' do
      fill_in "Title", with: "My text title"
      click_on "Create question"

      expect(page).to have_content("Body can't be blank")
    end

    scenario 'user ask a question with attache file' do
      fill_in "Title", with: "My text title"
      fill_in "Body", with: "My text text text body"

      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on "Create question"

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'Guest user' do
    background { visit questions_path }
    scenario 'does not see button Ask' do
      expect(page).to_not have_selector(:link_or_button, 'Ask')
    end
  end
end
