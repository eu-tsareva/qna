require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #show' do
    it 'renders show view' do
      get :show, params: { id: create(:answer) }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:action) { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

      it 'saves a new answer to the given question to database' do
        expect { action }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        expect(action).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes' do
      let(:action) { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }

      it 'does not save answer' do
        expect { action }.not_to change(question.answers, :count)
      end

      it 're-renders new view' do
        expect(action).to render_template(:new)
      end
    end
  end
end
