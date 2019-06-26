require 'rails_helper'

feature 'User can choose the best answer for his question', %q(
  An an author of the question
  I'd like to be able to mark answer as the best one
  For my qustion
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, user: user, question: question) }

  scenario 'Unauthenticated user wants to mark answer as the best' do
    visit question_path(question)

    expect(page).to have_no_content('Mark as the Best')
  end

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'marks answer as the best to his question', js: true do
      visit question_path(question)

      within("#answer-#{answers.last.id}") do
        click_on 'Mark as the Best'
        expect(page).to have_content 'Best Answer'
      end

      expect(page).to have_tag('.answer:first-child', id: "#answer-#{answers.last.id}")

    end

    scenario 'marks two answers as the best to his question', js: true do
      visit question_path(question)

      within("#answer-#{answers.first.id}") { click_on 'Mark as the Best' }
      within("#answer-#{answers.last.id}") { click_on 'Mark as the Best' }

      expect(page).to have_content('Best Answer', count: 1)
      within("#answer-#{answers.last.id}") do
        expect(page).to have_content 'Best Answer'
      end
    end

    scenario 'tries to mark answer as the best to other user question' do
      visit question_path(create(:answer).question)

      within('.answer') do
        expect(page).to have_no_content('Mark as the Best')
      end
    end
  end
end

feature 'User can see the best answer for the question', %q(
  I'd like to be able to see the best answer
  To any question at the top of the page
) do

  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question) }
  given!(:best_answer) { create(:answer, question: question, best: true) }

  scenario 'User sees the best answer first on the page' do
    visit question_path(question)

    within('.answer:first-child') do
      expect(page).to have_content('Best Answer')
    end
  end
end


