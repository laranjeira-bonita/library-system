require 'rails_helper'

RSpec.describe Rental, type: :model do
  let(:user) { User.create(name: "John Doe", email: "john.doe@example.com") }
  let(:book) { Book.create(title: "Pride and Prejudice", synopsis: "A novel", author: Author.create(name: "Jane Austen")) }
  let(:rental) { Rental.new(user: user, book: book, start_date: Date.today, end_date: Date.today + 2) }

  describe 'validations' do
    it 'is valid with a user, book, start_date, and end_date' do
      expect(rental).to be_valid
    end

    it 'is invalid if rent_days is less than 1' do
      rental.end_date = rental.start_date
      expect(rental).not_to be_valid
      expect(rental.errors[:name]).to include('The book should be rent for at least 1 day')
    end

    it 'is invalid if the book is already rented out during the requested period' do
      Rental.create(user: user, book: book, start_date: Date.today, end_date: Date.today + 1, status: :rent_out)
      rental.start_date = Date.today
      rental.end_date = Date.today + 1
      expect(rental).not_to be_valid
      expect(rental.errors[:date]).to include('Book rent out')
    end
  end

  describe 'custom methods' do
    it 'calculates the rent days correctly' do
      expect(rental.rent_days).to eq(1)
    end

    it 'calculates the real rent days correctly' do
      rental.start_date = Date.today - 2
      expect(rental.real_rent_days).to eq(2)
    end

    it 'calculates the original price correctly' do
      book.update(price_per_day: 10.0)
      expect(rental.original_price).to eq(10.0)
    end

    it 'calculates the price correctly' do
      book.update(price_per_day: 10.0)
      rental.pay!
      expect(rental.price).to eq(10.0)
    end

    it 'calculates the real price when returned' do
      book.update(price_per_day: 10.0)
      rental.return!
      expect(rental.price).to eq(0.0)  # Assuming the price is recalculated for returned rentals
    end
  end

  describe 'status transitions' do
    it 'sets the status to rent_out when pay! is called' do
      rental.pay!
      expect(rental.status).to eq('rent_out')
    end

    it 'sets the status to returned when return! is called' do
      rental.return!
      expect(rental.status).to eq('returned')
    end

    it 'sets the status to completed when complete! is called' do
      rental.complete!
      expect(rental.status).to eq('completed')
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      expect(rental.user).to eq(user)
    end

    it 'belongs to a book' do
      expect(rental.book).to eq(book)
    end
  end
end
