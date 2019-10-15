
require 'rails_helper'

feature 'Gist link' do
  given(:question) { create(:question, :with_links) }

  scenario 'show content without link' do
    visit question_path(question)
    within '.links' do
      expect(page).to_not have_link 'Gist'
    end
  end
end

