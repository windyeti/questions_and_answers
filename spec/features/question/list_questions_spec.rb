require 'rails_helper'

feature 'Guest look at list of questions', %q{
    User can look at list of questions
    to given an answer
} do
  given!(:questions) { create_list(:question, 4) }

  scenario 'list of questions exists' do
    visit questions_path
    questions.each { |question| expect(page).to have_content question.title }
  end
end
