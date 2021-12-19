require 'rails_helper'

RSpec.describe 'Home features' do
  describe 'Index' do
    it 'should have url path' do
      visit('/')
      expect(current_path).to eql('/')
    end

    it 'should have title' do
      visit('/')
      expect(page).to have_content('User Queries')
    end

    it 'should have sign in url path' do
      visit('/')
      click_link('Sign In')
      expect(current_path).to eql('/users/sign_in')
    end

    it 'should have sign up url path' do
      visit('/')
      click_link('Sign Up')
      expect(current_path).to eql('/users/sign_up')
    end
  end
end
