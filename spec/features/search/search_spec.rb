require 'sphinx_helper'

feature 'User can searches' do
  given!(:question) { create(:question, body: 'My question body') }
  background { visit questions_path }

  scenario 'User searches for the question', js: true, sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'My question body'
      click_on 'Search'
      expect(page).to have_content 'My question body'
    end
  end
end
