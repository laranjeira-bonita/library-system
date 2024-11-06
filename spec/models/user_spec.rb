require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(name: "John Doe", email: "john.doe@example.com") }

  describe 'validations' do
    it 'is valid with a name and email' do
      expect(user).to be_valid
    end

    it 'is invalid without a name' do
      user.name = nil
      expect(user).not_to be_valid
    end

    it 'is invalid without an email' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'is invalid with a duplicate email' do
      User.create(name: "Jane Doe", email: "john.doe@example.com")
      user.email = "john.doe@example.com"
      expect(user).not_to be_valid
    end

    it 'is invalid with an incorrect email format' do
      user.email = 'invalid-email'
      expect(user).not_to be_valid
    end

    it 'is valid with a correct email format' do
      user.email = 'john.doe@example.com'
      expect(user).to be_valid
    end
  end

  describe 'associations' do
    it 'has many rentals' do
      expect(user.rentals).to eq([])
    end
  end
end
