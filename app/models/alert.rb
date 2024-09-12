class Alert < ApplicationRecord
  enum status: { created: 0, triggered: 1, deleted: 2, other: 3 }
  belongs_to :user

  validates :cryptocurrency, presence: true
  validates :target_price, presence: true
end
