require 'rails_helper'

feature 'Authenticated user answers the question', %q(
  An an authenticated user
  I'd like to be able to answer a question
) do

  given(:question) { create(:question) }

  scenario 'Authenticated user answers the question' do
    sign_in(create(:user))

    visit question_path(question)
    fill_in 'Body', with: 'My awesome answer'
    click_on 'Post your answer'

    expect(page).to have_content 'My awesome answer'
  end

  scenario "Authenticated user answers the question" do
    visit question_path(question)
    fill_in 'Body', with: 'My awesome answer'
    click_on 'Post your answer'

    expect(page).to have_no_content 'My awesome answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
