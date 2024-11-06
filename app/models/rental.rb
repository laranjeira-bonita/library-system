class Rental < ApplicationRecord
    belongs_to :user
    belongs_to :book
    validate :at_least_one_day, :check_book_available, on: :create
    enum status: {
        processing: 0,
        rent_out: 1,
        returned: 2,
        completed: 3
    }

    def pay!
        update(status: :rent_out)
    end

    def return!
        update(status: :returned, returned_at: Date.today)
    end

    def complete!
        update(status: :completed)
    end

    def at_least_one_day
        errors.add(:name, 'The book should be rent for at least 1 day') if rent_days < 1
    end

    def check_book_available
        errors.add(:date, 'Book rent out') if book.rentals.where(status: :rent_out).where("start_date <= ? AND end_date >= ?", end_date, start_date).exists?
        # the system allow users to rent books for future
        # if there's 2 orders processing, the guy who pays first will get the book
        #if a client reserve to return the book at 2025-11-05, then the book will only be available after the order completed or reserve start from 2025-11-06
    end

    def rent_days
        (end_date - start_date).to_i
    end

    def real_rent_days
        ( Date.today - start_date).to_i
    end

    def original_price
        rent_days * book.price_per_day.to_f
    end

    def real_price
        real_rent_days * book.price_per_day.to_f
    end

    def price 
        # if the client rent for today-tomorrow, he should pay the rental today before get the book, and if he returns after tomorrow, should pay the extra fee
        case status
        when 'processing', 'rent_out'
            original_price
        when 'returned'
            [real_price - original_price, 0].max
        end  
    end
end
