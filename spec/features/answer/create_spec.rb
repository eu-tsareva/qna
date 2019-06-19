require 'rails_helper'

feature 'Authenticated user answers the question', %q(
  An an authenticated user
  I'd like to be able to answer a question
) do

  given(:question) { create(:question) }

  describe 'Authenticated user ' do
    background do
      sign_in(create(:user))
      visit question_path(question)
    end

    scenario 'answers the question', js: true do
      fill_in 'Body', with: 'My awesome answer'
      click_on 'Post your answer'

      expect(current_path).to eq question_path(question)
      within('.question__answers') { expect(page).to have_content 'My awesome answer' }
    end

    scenario 'answers the question with errors', js: true do
      click_on 'Post your answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user answers the question' do
    visit question_path(question)
    fill_in 'Body', with: 'My awesome answer'
    click_on 'Post your answer'

    expect(page).to have_no_content 'My awesome answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
