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
    let(:action) { delete :destroy, params: { id: answer }, format: :js }

    context 'by author' do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'deletes answer' do
        expect { action }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy view' do
        expect(action).to render_template(:destroy)
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

      it 'flashes error message' do
        action
        expect(flash[:notice]).to eq 'You have no rights to delete this answer.'
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

  describe 'PATCH #best' do
    context 'by author' do
      let(:answer) { create(:answer, question: question) }
      let(:action) { patch :best, params: { id: answer }, format: :js }

      it 'assigns previous best answer to @best_before' do
        best_answer = create(:answer, question: question, best: true)
        action
        expect(assigns(:best_before)).to eq best_answer
      end

      it 'changes answer best attribute' do
        expect { action }.to change { answer.reload.best }.from(false).to(true)
      end

      it 'changes question best answer' do
        expect { action }.to change { question.reload.best_answer }.to(answer.reload)
      end

      it 'saves only one best answer for question' do
        best_answer = create(:answer, question: question, best: true)

        expect { action }
          .to change  { answer.reload.best }.from(false).to(true)
          .and change { best_answer.reload.best }.from(true).to(false)
          .and change { question.reload.best_answer }.from(best_answer).to(answer)
      end

      it 'renders best view' do
        expect(action).to render_template :best
      end

    end

    context 'by another user' do
      let(:question) { create(:question) }
      let(:answer) { create(:answer, question: question) }
      let(:action) { patch :best, params: { id: answer }, format: :js }

      it 'does not make answer the best' do
        expect { action }.not_to change(answer, :best)
      end

      it 'redirects to question' do
        expect(action).to redirect_to question
      end

      it 'flashes error message' do
        action
        expect(flash[:notice]).to eq 'You have no rights to do this action.'
      end
    end
  end
end
