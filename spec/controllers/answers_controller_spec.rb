require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:action) { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

      it 'saves new answer to the given question to database' do
        expect { action }.to change(question.answers, :count).by(1)
      end

      it 'saves new answer to the logged user' do
        expect { action }.to change(user.answers, :count).by(1)
      end

      it 'redirects to question' do
        expect(action).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let(:action) { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }

      it 'does not save answer' do
        expect { action }.not_to change(question.answers, :count)
      end

      it 'renders question show view' do
        expect(action).to render_template('questions/show')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:action) { delete :destroy, params: { id: answer } }

    context 'by author' do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'deletes answer' do
        expect { action }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show' do
        expect(action).to redirect_to question
      end
    end

    context 'by another user' do
      let!(:answer) { create(:answer, question: question, user: create(:user)) }

      it 'does not delete answer' do
        expect { action }.not_to change(Answer, :count)
      end

      it 'redirects to question show' do
        expect(action).to redirect_to question
      end
    end
  end
end
