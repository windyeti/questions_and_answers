require 'sphinx_helper'

feature 'User can search for answer' do
  given!(:question) { create(:question, body: 'My question body') }

  background do
    visit questions_path
  end
  scenario 'User searches for the answer', js: true, sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'My question body'
      click_on 'Search'
      p '++++++++++++++++++++++++'
      p Question.all
      p '++++++++++++++++++++++++'
save_and_open_page
      sleep 200
      expect(page).to have_content 'My question body'
    end
  end
end
