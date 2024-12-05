class User < ApplicationRecord
	validates :email, uniqueness: { case_sensitive: false, message: 'ID is already in use.' }
	validates :name, presence: true
end
