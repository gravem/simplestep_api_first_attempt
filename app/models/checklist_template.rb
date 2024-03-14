class ChecklistTemplate < ApplicationRecord
  belongs_to :user
  has_many :steps, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
end
