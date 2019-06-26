class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create update best destroy]

  def create
    @answer = question.answers.new(answer_params)
    answer.user = current_user
    answer.save
  end

  def update
    if current_user.author_of?(answer)
      answer.update(answer_params)
    else
      redirect_to answer.question, notice: 'You have no rights to edit this answer.'
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
    else
      redirect_to answer.question, notice: 'You have no rights to delete this answer.'
    end
  end

  def best
    if current_user.author_of?(answer.question)
      @best_before = answer.question.best_answer
      @best_before&.update_attribute(:best, false)
      answer.update_attribute(:best, true)
    else
      redirect_to answer.question, notice: 'You have no rights to do this action.'
    end
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
    params.require(:answer).permit(:body)
  end
end
