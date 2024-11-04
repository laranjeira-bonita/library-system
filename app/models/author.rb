class Author < ApplicationRecord
    has_many :books
    validates :name, presence: true, length: { maximum: 100 }
    before_destroy { throw(:abort) if books.any? }
end
