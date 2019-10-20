require 'rails_helper'

feature 'User can voting' do
  context 'Authenticated user' do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'can vote up' do
      within '.vote' do
        click_on "Vote Up"
      end
      expect(page).to have_content("reset vote")
    end

    # scenario 'user ask a question with invalid title field' do
    #   fill_in "Body", with: "My text text text body"
    #   click_on "Create question"
    #
    #   expect(page).to have_content("Title can't be blank")
    # end
    #
    # scenario 'user ask a question with invalid body field' do
    #   fill_in "Title", with: "My text title"
    #   click_on "Create question"
    #
    #   expect(page).to have_content("Body can't be blank")
    # end
    #
    # scenario 'user ask a question with attache file' do
    #   fill_in "Title", with: "My text title"
    #   fill_in "Body", with: "My text text text body"
    #
    #   attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
    #
    #   click_on "Create question"
    #
    #   expect(page).to have_link 'rails_helper.rb'
    #   expect(page).to have_link 'spec_helper.rb'
    # end
  end

  # context 'Guest user' do
  #   background { visit questions_path }
  #   scenario 'does not see button Ask' do
  #     expect(page).to_not have_selector(:link_or_button, 'Ask')
  #   end
  # end
end
