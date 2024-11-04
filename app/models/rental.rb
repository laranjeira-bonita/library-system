class Rental < ApplicationRecord
    belongs_to :user
    belongs_to :book
    validate :at_least_one_day
    enum status: {
        processing: 0,
        rent_out: 1,
        returned: 2,
        completed: 3
    }

    def at_least_one_day
        errors.add(:name, 'The book should be rent for at least 1 day') if rent_days < 1
    end

    def rent_days
        (end_date - start_date).to_i
    end

    def price
        rent_days * book.price_per_day.to_f
    end
end
