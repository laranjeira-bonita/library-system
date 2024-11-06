class Author < ApplicationRecord
    has_many :books
    validates :name, presence: true, length: { maximum: 100 }
    before_destroy { errors.add(:book, "#{name} has books") && throw(:abort) if books.any? }
end
