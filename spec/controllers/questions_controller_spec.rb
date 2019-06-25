require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'assigns new question answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end


  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      let(:action) { post :create, params: { question: attributes_for(:question) } }

      it 'saves new question to the database' do
        expect { action }.to change(Question, :count).by(1)
      end

      it 'saves new question to the logged user' do
        expect { action }.to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        expect(action).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.not_to change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'by author' do
      let!(:question) { create(:question, user: user) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          expect(assigns(:question)).to eq(question)
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
          question.reload
          expect(question.title).to eq('new title')
          expect(question.body).to eq('new body')
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:action) { patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js } }

        it 'does not change question' do
          expect { action }.to_not change(question, :title)
          expect { action }.to_not change(question, :body)
        end

        it 'renders update view' do
          expect(action).to render_template :update
        end
      end
    end

    context 'by another user' do
      let(:action) { patch :update, params: { id: question, question: attributes_for(:question), format: :js } }

      it 'does not edit answer' do
        expect { action }.to_not change(question, :title)
        expect { action }.to_not change(question, :body)
      end

      it 'redirects to question' do
        expect(action).to redirect_to question
      end

      it 'flashes error message' do
        action
        expect(flash[:notice]).to eq 'You have no rights to edit this question.'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let(:action) { delete :destroy, params: { id: question } }

    context 'by author' do
      let!(:question) { create(:question, user: user) }

      it 'deletes the question' do
        expect { action }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        expect(action).to redirect_to questions_path
      end
    end

    context 'by another user' do
      let!(:question) { create(:question, user: create(:user)) }

      it 'does not delete the question' do
        expect { action }.not_to change(Question, :count)
      end

      it 'redirects to show' do
        expect(action).to redirect_to question
      end
    end
  end
end
