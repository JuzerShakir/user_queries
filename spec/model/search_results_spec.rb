require 'rails_helper'

RSpec.describe SearchResult, type: :model do
  let (:user) { User.create(email: 'test@gmail.com', password: '123456') }
  subject { user.search_results.new(adwords_count: 7, links_count: 50 ) }

  describe 'Validations' do
    describe 'Links' do
      it 'must be only integer' do
        expect(subject).to be_valid
        subject.links_count = 'string'
        # it will convert string to integer in db, for a-z values it will return 0
        expect(subject.links_count).to eql(0)
      end
    end

    describe 'Adwords' do
      it 'must be only integer' do
        expect(subject).to be_valid
        subject.adwords_count = 'string'
        expect(subject.adwords_count).to eql(0)
      end
    end
  end

  describe 'Association' do
    it { should belong_to(:user) }
  end
end
