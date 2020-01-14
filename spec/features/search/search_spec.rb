require 'sphinx_helper'

feature 'User can searches', js: true, sphinx: true do
  given!(:question) { create(:question, body: 'My question body') }
  given!(:answer) { create(:answer, body: 'My answer body') }
  background { visit questions_path }

  scenario 'User searches for the question' do
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'My*'
      select 'Question', from: 'scope'
      click_on 'Search'

      expect(page).to have_content 'My question body'
      expect(page).to_not have_content 'My answer body'
    end
  end
end
