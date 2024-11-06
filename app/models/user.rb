class User < ApplicationRecord
    has_many :rentals, dependent: :destroy
    validates :name, presence: true
    validates :email, uniqueness: true, presence: true, format: { with: /\A([^\s]?[\w\-+.\/"\%\!]+)@([A-Za-z\d\-\[\]\.\:\(\)]+)\z/i }, on: :create
    before_destroy { errors.add(:rental, "#{name} has rentals") && throw(:abort) if rentals.exists?(status: :rent_out) }
end
