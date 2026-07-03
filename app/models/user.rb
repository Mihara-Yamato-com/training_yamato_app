class User < ApplicationRecord

  enum :role, { general: 0, admin: 1 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }, 
  validates :email, presence: true, length: { maximum: 254 }, uniqueness: true,
  validates :encrypted_password, presence: true, length: { minimum: 8 }

end
