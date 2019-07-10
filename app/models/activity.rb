class Activity < ApplicationRecord
  validates :contact_id, :description, presence: true
  belongs_to :contact
end
