require 'rails_helper'

feature 'User can see a question with answers', %q{

} do
  given(:user) { create(:user) }
  background { sign_in(user) }

  given!(:question) { user.questions.create(attributes_for(:question)) }

  scenario 'show question with his answers' do
    visit questions_path
    click_on 'Show'

    fill_in 'answer_body', with: 'My Answer 1 text'
    click_on 'Create answer'
    fill_in 'answer_body', with: 'My Answer 2 text'
    click_on 'Create answer'

    expect(page).to have_content('List answers')
    expect(page).to have_content('My Answer 1 text')
    expect(page).to have_content('My Answer 2 text')
  end
end
