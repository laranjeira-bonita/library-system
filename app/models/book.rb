class Book < ApplicationRecord
    has_many :rentals
    belongs_to :author
    validates :title, presence: true
    before_destroy { errors.add(:rental, "#{title} has rentals") && throw(:abort) if rentals.exists?(status: :rent_out) }
end
