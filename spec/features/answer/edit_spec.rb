require 'rails_helper'

feature 'Only authenticated user can edit answer' do
  context 'Authenticated user' do
    scenario 'with valid data'
    scenario 'with invalid data'
  end

  context 'Not author can not edit answer' do
    scenario 'other user'
    scenario 'guest'
  end
end
