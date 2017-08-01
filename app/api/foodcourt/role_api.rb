module Foodcourt
  class RoleApi < Grape::API

    resource :role do
      desc "List all Role"
      get do
        role_data = []
        Role.all
            .each do |role|
              role_data << {
                id: role.id,
                name: role.name,
                description: role.description,
                created_at: role.created_at,
                updated_at: role.updated_at
              }
            end

        {
          total: Role.count,
          count: role_data.count,
          data: role_data
        }
      end

      desc 'Get a Role.'
      params do
        requires :id, type: Integer, desc: 'Role id.'
      end
      route_param :id do
        get do
          role = Role.where(id: params[:id]).first

          {
            data: {
              id: role.id,
              name: role.name,
              description: role.description,
              created_at: role.created_at,
              updated_at: role.updated_at
            }
          }
        end
      end
    end

  end
end
