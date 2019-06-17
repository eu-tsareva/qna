require 'rails_helper'

feature 'User can sign up', %q(
  In order to ask questions and answers
  I'd like to be able to sign up
) do

  background do
    visit root_path
    click_on 'Sign up'
  end

  scenario 'User successfully signs up' do
    fill_in 'Email', with: 'user@email.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    find('input[type=submit]').click

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User unsuccessfully signs up' do
    fill_in 'Email', with: 'user@email.com'
    fill_in 'Password', with: '123'
    fill_in 'Password confirmation', with: '1234'
    find('input[type=submit]').click

    expect(page).to have_css '#error_explanation'
  end
end
