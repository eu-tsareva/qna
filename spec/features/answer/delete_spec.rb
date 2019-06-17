require 'rails_helper'

feature 'User can delete his own answer', %q(
  As an author of the answer
  I'd like to be able to delete my answer
) do

  given(:user1) { create(:user) }
  given(:question) { create(:question, user: create(:user)) }

  background { sign_in(user1) }

  scenario 'User deletes his answer', js: true, driver: :webkit do
    create(:answer, question: question, user: user1)
    visit question_path(question)

    within('.answer .answer__actions') { click_link 'Delete' }

    page.driver.browser.accept_js_confirms

    expect(page).to have_content 'Your answer was successfully deleted.'
    expect(page).to have_no_css '.answer'
  end

  scenario 'User wants to delete another user answer' do
    create(:answer, question: question, user: create(:user))
    visit question_path(question)

    expect(page).to have_no_css '.answer a[data-method=delete]'
  end
end
