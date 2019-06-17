require 'rails_helper'

feature 'User can see all questions', %q(
  I'd like to be able to browse through questions
  Even if i am not a registered user
) do

  scenario 'User opens question list' do
    create_list(:question, 3)
    visit questions_path

    expect(page).to have_css('.questions li', count: 3)
  end
end

feature 'User can see a question with its answers', %q(
  I'd like to be able to browse see a question with its answers
  Even if i am not a registered user
) do

  given(:question) { create(:question) }

  scenario 'User can see a question and its answers' do
    create_list(:answer, 3, question: question, user: create(:user))
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_css('.answer', count: 3)
    expect(page).to have_content question.answers.first.body
  end
end
