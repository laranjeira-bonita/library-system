class User < ApplicationRecord
    has_many :rentals
    validates :name, presence: true
    validates :email, uniqueness: true, presence: true, format: { with: /\A([^\s]?[\w\-+.\/"\%\!]+)@([A-Za-z\d\-\[\]\.\:\(\)]+)\z/i }, on: :create
end
