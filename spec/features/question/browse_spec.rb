require 'rails_helper'

feature 'User can see all questions', %q(
  I'd like to be able to browse through questions
  Even if i am not a registered user
) do

  scenario 'User opens question list' do
    questions = create_list(:question, 3)
    visit questions_path

    questions.each { |question| expect(page).to have_content(question.title) }
  end
end

feature 'User can see a question with its answers', %q(
  I'd like to be able to browse see a question with its answers
  Even if i am not a registered user
) do

  given(:question) { create(:question) }

  scenario 'User can see a question and its answers' do
    answers = create_list(:answer, 3, question: question, user: create(:user))
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end
