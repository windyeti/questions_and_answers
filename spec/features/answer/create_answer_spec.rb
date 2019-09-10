require 'rails_helper'

feature 'User can create an answer on the page question', %q{
  When user visit page of question
  then can create answer
} do
  given(:user) { create(:user) }
  background { sign_in(user) }

  given(:question) { user.questions.create(attributes_for(:question)) }
  given!(:answer) { question.answers.create(attributes_for(:answer)) }

  background {

    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
  }

  scenario 'with valid body field' do
    fill_in 'answer_body', with: 'My text answer'

    click_on 'Create answer'

    expect(page).to have_content('My text answer')
  end

  scenario 'with invalid body field' do
    click_on 'Create answer'

    expect(page).to have_content("Body can't be blank")
  end
end
