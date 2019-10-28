
require 'rails_helper'

feature 'Vote value in answer' do
  context 'Guest', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question) }
    given(:answer) { create(:answer, question: question) }
    given!(:vote) { create(:vote, voteable: answer, user: user, value: 1) }

    background do
      visit question_path(question)
    end
    scenario 'can see vote value' do
      within '.answer .vote__balance' do
        expect(find(".vote__value")).to have_content '1'
      end
    end
  end
end
