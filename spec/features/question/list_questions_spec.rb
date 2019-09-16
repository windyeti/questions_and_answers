require 'rails_helper'

feature 'Guest look at list of questions', %q{
    User can look at list of questions
    to given an answer
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 4, title: 'My title text', body: 'My body text text 456') }

  scenario 'look list of questions' do
    visit questions_path
    expect(page).to have_content('My title text')
    expect(page).to have_content('My body text text 456')
  end
end
