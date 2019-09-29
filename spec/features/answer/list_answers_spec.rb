require 'rails_helper'

feature 'User can see a answers on the page of question' do
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question) }

  scenario 'show question with his answers' do
    visit questions_path

    click_on 'Show'
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
