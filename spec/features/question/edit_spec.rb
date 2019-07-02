require 'rails_helper'

feature 'User can edit his question', %q(
  In order to correct mistakes
  As an author of the question
  I'd like to  be able to edit my question
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }


  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    within('.question') do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his question', js: true do
      within('.question') do
        click_on 'Edit'
        fill_in 'Title', with: 'new title'
        fill_in 'Body', with: 'new body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'new title'
        expect(page).to have_content 'new body'
        expect(page).to_not have_selector 'form'
      end
    end

    scenario 'edits his question with errors', js: true do
      within('.question') do
        click_on 'Edit'
        fill_in 'Title', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
      end
    end

    scenario "tries to edit other user's question" do
      visit question_path(create(:question))

      within('.question') do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
