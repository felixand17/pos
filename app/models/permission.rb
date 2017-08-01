class Permission < ApplicationRecord
  has_many  :role_permissions
  has_many  :roles, through: :role_permissions

  has_paper_trail
end
