feature 'Only author can edit his question' do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }

  scenario 'Authenticated user can edit question' do
    visit question_path(question)
    click_on 'Edit'

    fill_in 'Title', with: 'New title'
    click_on 'Save'

    expect(page).to have_content 'New title'
  end

  scenario 'Unauthenticated user cannot edit question'
  scenario 'Authenticated user not author cannot edit question'
  scenario 'Authenticated user enters invalid data when edits question'
end
