require 'rails_helper'

feature 'User create question', %q{
  To resolve issue
} do
  given(:user) { create(:user) }

  background {
    sign_in(user)

    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content("Create question")
  }
  scenario 'user ask a question with valid fields' do
    fill_in "question_title", with: "My text title"
    fill_in "question_body", with: "My text text text body"
    click_on "Ask"

    expect(page).to have_content("My text title")
    expect(page).to have_content("My text text text body")
  end

  scenario 'user ask a question with invalid title field' do
    fill_in "question_body", with: "My text text text body"
    click_on "Ask"

    expect(page).to have_content("Title can't be blank")
  end

  scenario 'user ask a question with invalid body field' do
    fill_in "question_title", with: "My text title"
    click_on "Ask"

    expect(page).to have_content("Body can't be blank")
  end
end
