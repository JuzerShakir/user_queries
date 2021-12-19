require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(email: 'test@gmail.com', password: '123456')}

  describe 'Validation' do
    describe 'email' do
      it 'must be present' do
        expect(subject).to be_valid
        subject.email = nil
        expect(subject).to_not be_valid
      end

      it 'must be in valid format' do
        expect(subject).to be_valid
        subject.email = 'abd'
        expect(subject).to_not be_valid
      end
    end

    describe 'password' do
      it 'must be present' do
        expect(subject).to be_valid
        subject.password = nil
        expect(subject).to_not be_valid
      end

      it 'must have minimum length' do
        expect(subject).to be_valid
        subject.password = '@3'
        expect(subject).to_not be_valid
      end
    end

    describe 'associations' do
      it { should have_many(:search_results) }
    end
  end
end
