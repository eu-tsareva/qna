require 'rails_helper'

feature 'User can delete his own question', %q(
  As an author of the question
  I'd like to be able to delete my question
) do

  given(:user1) { create(:user) }

  describe 'Authenticated user' do
    background { sign_in(user1) }

    scenario 'deletes his question', js: true, driver: :webkit do
      questions = create_list(:question, 3, user: user1)
      visit question_path(questions.first)

      click_link 'Delete'
      page.driver.browser.accept_js_confirms

      expect(page).to have_content 'Your question was successfully deleted.'
      expect(page).to have_no_content questions.first.title
    end

    scenario 'wants to delete another user question' do
      question = create(:question, user: create(:user))
      visit question_path(question)

      expect(page).to have_no_link 'Delete'
    end
  end

  scenario 'Unauthenticated user wants to delete question' do
    question = create(:question, user: user1)
    visit question_path(question)

    expect(page).to have_no_link 'Delete'
  end
end
