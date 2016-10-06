class Card < ActiveRecord::Base

  # Validations
  validates :card_number, length: {is: 7}, uniqueness: true, include_blank: false

  # Relations
  has_one :user
  has_many :answers
end
