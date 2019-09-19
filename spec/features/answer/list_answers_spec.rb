require 'rails_helper'

feature 'User can see a answers on the page of question' do
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question, body: 'My Answer 23456 text') }

  scenario 'show question with his answers' do
    visit questions_path

    click_on 'Show'

    expect(page).to have_content('List answers')
    expect(page).to have_content('My Answer 23456 text')
  end
end
