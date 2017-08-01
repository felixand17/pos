class Menu < ApplicationRecord
  acts_as_paranoid

  belongs_to :category
  belongs_to :tenant

  has_many  :order_details

  has_paper_trail

  mount_uploader :picture, MenuUploader

  scope :search, -> (keyword) {
    where(
      "lower(menus.name) like :q OR lower(tenants.name) like :q",
      { q: "%#{keyword}%" }
    )
  }
  scope :filter_sold_out, -> { where(availability: false) }
  scope :filter_available, -> { where(availability: true) }

  scope :by_tenant, -> (tenant) {
    where(tenant_id: tenant)
  }

  def to_available!
    update_attribute(:availability, true)
  end

  def to_sold_out!
    update_attribute(:availability, false)
  end
end
