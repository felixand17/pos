class User < ApplicationRecord
  acts_as_token_authenticatable
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :session_limitable

  has_many :orders
  has_many :sales
  has_many :notifications
  has_one  :tenant, dependent: :destroy
  belongs_to  :role

  has_paper_trail

  scope :management, -> { where("roles.name != ? AND users.email NOT LIKE '%@root.system' ", 'Tenant') }
  before_create :fill_confirmed_at

  # Override password checking for validation
  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end

  # Disable email confirmation
  def send_confirmation_notification?
    false
  end

  def fill_confirmed_at
    self.confirmed_at = Time.now.utc
  end

  # Role Group
  def admin?
    self.role.name == "Admin"
  end

  def tenant?
    self.role.name == "Tenant"
  end

  def waitres?
    self.role.name == "Waiters" || self.role.name == "Waitres"
  end

  def cashier?
    self.role.name == "Cashier"
  end
end
