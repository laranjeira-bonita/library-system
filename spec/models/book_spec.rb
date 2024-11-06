require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:author) { Author.create(name: "Jane Austen") }
  let(:book) { Book.new(title: "Pride and Prejudice", synopsis: "A synopsis", author: author, price_per_day: 10.00) }
  let(:user) { User.create(name: "John Doe", email: "john.doe@example.com") }

  describe 'validations' do
    it 'is valid with a title, synopsis, and author' do
      expect(book).to be_valid
    end

    it 'is invalid without a title' do
      book.title = nil
      expect(book).not_to be_valid
    end

    it 'is invalid without an author' do
      book.author = nil
      expect(book).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to an author' do
      expect(book.author).to eq(author)
    end

    it 'has many rentals' do
      expect(book.rentals).to eq([])
    end
  end

  describe 'price_per_day' do
    it 'has a default value of 0.0 if not specified' do
      new_book = Book.new(title: "Emma", synopsis: "Another synopsis", author: author)
      expect(new_book.price_per_day).to eq(0.0)
    end

    it 'saves the price with up to 2 decimal places' do
      book.price_per_day = 12.3456
      book.save
      expect(book.reload.price_per_day).to eq(12.35)
    end
  end

  describe 'before_destroy callback' do
    context 'when the book has rentals' do
      before do
        book.save
        book.rentals.create(start_date: 2.days.ago, end_date: 2.days.from_now, user_id: user.id, status: :rent_out)
      end

      it 'does not allow the book to be destroyed' do
        expect(book.destroy).to be_falsey
      end

      it 'adds an error message to the book' do
        book.destroy
        expect(book.errors[:rental]).to include("#{book.title} has rentals")
      end
    end

    context 'when the book has no rentals' do
      it 'allows the book to be destroyed' do
        expect(book.destroy).to be_truthy
      end
    end
  end
end
