require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  describe '#mark_as_best!' do
    let(:question) { create(:question) }
    let(:answers) { create_list(:answer, 3, question: question) }
    let(:answer) { answers.first }

    it "sets best to 'true' for this answer" do
      expect { answer.mark_as_best! }.to change { answer.reload.best }.from(false).to(true)
    end

    it "sets best to 'false' for previous best answer" do
      best_answer = create(:answer, question: question, best: true)
      expect { answer.mark_as_best! }.to change { best_answer.reload.best }.from(true).to(false)
    end
  end
end
