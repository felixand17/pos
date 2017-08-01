class Role < ApplicationRecord
  has_many  :users
  has_many  :role_permissions
  has_many  :permissions, through: :role_permissions

  has_paper_trail

  def update_permissions(data_permission = [])
    ActiveRecord::Base.transaction do
      permissions.delete_all
      data_permission.each do |id|
        permission = Permission.where(id: id).first
        permissions << permission
      end
    end
  end
end
