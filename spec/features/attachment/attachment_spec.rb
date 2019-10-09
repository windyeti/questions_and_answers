require 'rails_helper'

feature 'Delete attached file' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_attachment, user: user ) }


  context "Authenticated user", js: true do
    background { sign_in(user) }

    scenario 'can delete attached file from his question' do
      visit question_path(question)
      within '.question' do
        expect(page).to have_content 'rails_helper.rb'
        expect(page).to have_content 'spec_helper.rb'
      end

      within "#attachment_id_#{question.files[0].id}" do
        click_on 'Delete'
        expect(page).to_not have_content 'rails_helper.rb'
      end
    end
  end

  context "Authenticated user not author" do
    given(:other_user) { create(:user) }
    background { sign_in(other_user) }

    scenario 'can not delete attached file' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_selector(:link_or_button, 'Delete')
      end
    end
  end

  context "Guest" do
    scenario 'can not delete attached files' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_selector(:link_or_button, 'Delete')
      end
    end
  end
end
