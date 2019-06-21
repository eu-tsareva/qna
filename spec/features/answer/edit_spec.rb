require 'rails_helper'

feature 'User can edit his answer', %q(
  In order to correct mistakes
  As an author of the answer
  I'd like to  be able to edit my answer
) do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    within('.answer') do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in(user)
      visit question_path(question)

      within('.answer') do
        click_on 'Edit'
      end

      within('.question__answers') do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
    scenario 'edits his answer with errors'
    scenario "tries to edit other user's answer"
  end
end
