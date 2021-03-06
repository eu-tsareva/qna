class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def mark_as_best!
    transaction do
      question.best_answer&.update!(best: false)
      update!(best: true)
    end
  end
end
