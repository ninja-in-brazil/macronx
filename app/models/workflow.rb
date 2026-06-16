class Workflow < ApplicationRecord
  has_many :inboxes

  validates :name, presence: true
end
