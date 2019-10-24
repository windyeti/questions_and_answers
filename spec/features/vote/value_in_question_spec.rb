require 'rails_helper'

feature 'Vote value' do
  context 'Guest', js: true do
    given(:question) { create(:question) }
    given(:user) { create(:user) }
    given!(:vote) { create(:vote, voteable: question, user: user) }

    background do
      visit question_path(question)
    end
    scenario 'can see vote value' do
      within '.question .vote__balance' do
        expect(find(".vote__value")).to have_content '1'
      end
    end
  end
end
