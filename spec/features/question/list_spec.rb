require 'rails_helper'

feature 'User can look at list of questions', %q{
    User can look at list of questions
    to given an answer
} do
  scenario 'look list of questions' do
    visit questions_path
    expect(page).to have_content('Title')
    expect(page).to have_content('Question')
  end
end
