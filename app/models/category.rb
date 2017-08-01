class Category < ApplicationRecord
  acts_as_paranoid

  has_many :menus

  has_paper_trail
end
