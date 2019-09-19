module FeatureHelper
  def user_sign_up_with_data
    visit new_user_registration_path
    fill_in 'Email', with: 'user21@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
  end
end
