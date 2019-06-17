class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def show
  end

  def create
    answer = question.answers.new(answer_params)
    answer.user = current_user
    if answer.save
      redirect_to question, notice: 'Your answer was successfully created'
    else
      redirect_to question
    end
  end

  def destroy
    answer.destroy
    redirect_to answer.question, notice: 'Your answer was successfully deleted.'
  end

  private

  helper_method :question, :answer

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new
  end

  def answer_params
    params.require(:answer).permit(:body, :user_id)
  end
end
