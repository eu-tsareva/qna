require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  before { login(create(:user)) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:action) { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

      it 'saves a new answer to the given question to database' do
        expect { action }.to change(question.answers, :count).by(1)
      end

      it 'redirects to qustion' do
        expect(action).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let(:action) { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }

      it 'does not save answer' do
        expect { action }.not_to change(question.answers, :count)
      end

      it 'redirects to qustion' do
        expect(action).to redirect_to question
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question) }

    it 'deletes the question' do
      expect { delete :destroy, params: { id: answer } }
        .to change(question.answers, :count)
        .by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question
    end
  end
end
