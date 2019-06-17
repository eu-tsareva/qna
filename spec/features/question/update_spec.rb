require 'rails_helper'

feature 'User can edit his own question', %q(
  As an author of the question
  I'd like to be able to edit this question
) do

  given(:user1) { create(:user) }

  background { sign_in(user1) }

  describe 'User edits his own question' do
    background do
      question1 = create(:question, user: user1)
      visit question_path(question1)
      click_on 'Edit'
    end

    scenario 'with valid data' do
      fill_in 'Title', with: 'New title'
      click_on 'Ask'

      expect(page).to have_content 'Your question was successfully updated.'
      expect(page).to have_content 'New title'
      expect(page).to have_content 'MyText'
    end

    scenario 'with invalid data' do
      fill_in 'Body', with: ''
      click_on 'Ask'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'User wants to edit another user question' do
    question2 = create(:question, user: create(:user))
    visit question_path(question2)

    expect(page).to have_no_content 'Edit'
  end
end
