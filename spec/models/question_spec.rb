require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe '#best_answer' do
    let(:question) { create(:question) }
    let(:answers) { create_list(:answer, 3, question: question) }

    it 'returns nil if no answer has best = true' do
      expect(question.best_answer).to be nil
    end

    it 'returns first answer with best = true' do
      best_answer = create(:answer, question: question, best: true)
      expect(question.best_answer).to eq best_answer
    end
  end
end
