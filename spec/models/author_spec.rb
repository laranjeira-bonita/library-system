require 'rails_helper'

RSpec.describe Author, type: :model do
  let(:author) { Author.new(name: "Jane Austen") }

  describe 'validations' do
    it 'is valid with a name' do
      expect(author).to be_valid
    end

    it 'is invalid without a name' do
      author.name = nil
      expect(author).not_to be_valid
    end

    it 'is invalid if the name is too long' do
      author.name = 'a' * 101
      expect(author).not_to be_valid
    end
  end

  describe 'callbacks' do
    it 'prevents deletion if author has books' do
      author.save
      author.books.create(title: 'Sample Book', synopsis: 'A synopsis')
      expect { author.destroy }.not_to change(Author, :count)
    end
  end
end
