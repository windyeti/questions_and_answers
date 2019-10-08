require 'rails_helper'

feature 'Only authenticate user can delete own answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user ) }
  given!(:answer) { create(:answer, :with_attachment, question: question, user: user, body: 'MY BODY ANSWER') }

  context 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'can delete own answer' do
      visit question_path(question)
      expect(page).to have_content 'MY BODY ANSWER'
      within '.answer > p' do
        click_on 'Delete'
      end

      expect(page).to_not have_content 'MY BODY ANSWER'
    end

    # scenario 'can delete attachment file' do
    #   visit question_path(question)
    #
    #   within '.answer__attachment' do
    #     expect(page).to have_content 'rails_helper.rb'
    #     expect(page).to have_content 'spec_helper.rb'
    #   end
    #
    #   within "#attachment_id_#{answer.files[0].id}" do
    #     click_on 'Delete'
    #     expect(page).to_not have_content 'rails_helper.rb'
    #   end
    #
    # end
  end

  context 'Authenticated user not author ' do
    given(:other_user) { create(:user) }
    background { sign_in(other_user) }

    scenario 'can not delete answer' do
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end

    context 'Guest user' do

      scenario 'can not delete answer' do
        visit question_path(question)

        expect(page).to_not have_selector(:link_or_button, 'Delete')
      end
    end
  end


end

