require 'rails_helper'

feature 'User can look at list of questions', %q{
    User can look at list of questions
    to given an answer
} do
  given(:user) { create(:user) }
  background { sign_in(user) }
  given!(:question) { user.questions.create(title: 'My title text', body: 'My body text text') }

  scenario 'look list of questions' do
    visit questions_path
    expect(page).to have_content('My title text')
    expect(page).to have_content('My body text text')
  end
end
