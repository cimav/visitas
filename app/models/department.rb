class Department < ApplicationRecord
  has_many :rooms
  has_many :visits
end
