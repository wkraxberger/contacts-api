class Contact < ApplicationRecord
  validates :first_name, :last_name, :cell_phone, :zip_code, presence: true
  has_many :activities, dependent: :destroy
end
