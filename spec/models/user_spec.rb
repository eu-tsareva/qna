require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }

    it 'returns true if user is the author of the resource' do
      question = create(:question, user: user)
      expect(user).to be_an_author_of(question)
    end

    it 'returns false if user is not the author of the resource' do
      question = create(:question, user: create(:user))
      expect(user).not_to be_an_author_of(question)
    end
  end
end
