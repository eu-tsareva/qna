require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:action) { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }

      it 'saves new answer to the given question to database' do
        expect { action }.to change(question.answers, :count).by(1)
      end

      it 'saves new answer to the logged user' do
        expect { action }.to change(user.answers, :count).by(1)
      end

      it 'renders create' do
        expect(action).to render_template(:create)
      end
    end

    context 'with invalid attributes' do
      let(:action) { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }

      it 'does not save answer' do
        expect { action }.not_to change(question.answers, :count)
      end

      it 'renders create' do
        expect(action).to render_template(:create)
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

      it 'redirects to question' do
        expect(action).to redirect_to question
      end
    end
  end

  describe 'PATCH #update' do
    context 'by author' do
      let!(:answer) { create(:answer, question: question, user: user) }

      context 'with valid attributes' do
        let(:action) { patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js }

        it 'changes answer attributes' do
          action
          answer.reload
          expect(answer.body).to eq('new body')
        end

        it 'renders update view' do
          expect(action).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:action) { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

        it 'does not change answer attributes' do
          expect { action }.to_not change(answer, :body)
        end

        it 'renders update view' do
          expect(action).to render_template :update
        end
      end
    end

    context 'by another user' do
      let!(:answer) { create(:answer, question: question, user: create(:user)) }
      let(:action) { patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js }

      it 'does not edit answer' do
        expect { action }.not_to change(answer, :body)
      end

      it 'redirects to question' do
        expect(action).to redirect_to question
      end

      it 'flashes error message' do
        action
        expect(flash[:notice]).to eq 'You have no rights to edit this answer.'
      end
    end
  end
end
