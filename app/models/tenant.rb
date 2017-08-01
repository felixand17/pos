class Tenant < ApplicationRecord
  acts_as_paranoid

  has_many :order_details
  has_many :menus

  belongs_to  :user, dependent: :destroy
  accepts_nested_attributes_for :user, allow_destroy: true

  has_paper_trail
end
