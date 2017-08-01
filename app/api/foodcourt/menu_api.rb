module Foodcourt
  class MenuApi < Grape::API

    resource :menu do
      desc "List all Menu"
      get do
        q = "#{params[:keyword]}"
        limit = ( params[:limit].to_i == 0 || params[:limit].empty? ) ? Menu.count : params[:limit]
        offset = params[:offset]

        menu_data = []
        Menu.joins(:tenant)
            .search(q)
            .limit(limit)
            .offset(offset)
            .each do |menu|
              menu_data << {
                id: menu.id,
                picture: menu.picture.url,
                name: menu.name,
                description: menu.description,
                price: menu.price,
                availability: menu.availability,
                tenant: {
                  id: menu.tenant_id,
                  name: menu.tenant.name,
                  acronym: ApplicationController.helpers.acronym_text(menu.tenant.name)
                },
                category: {
                  id: menu.category_id,
                  name: menu.category.name
                },
                created_at: menu.created_at,
                updated_at: menu.updated_at
              }
            end

        {
          total: Menu.includes(:tenant).references(:tenant).search(q).count,
          count: menu_data.count,
          data: menu_data
        }
      end

      desc 'Get a Menu.'
      params do
        requires :id, type: Integer, desc: 'Menu id.'
      end
      route_param :id do
        get do
          menu = Menu.where(id: params[:id]).first

          {
            data: {
              id: menu.id,
              picture: menu.picture.url,
              name: menu.name,
              description: menu.description,
              price: menu.price,
              availability: menu.availability,
              tenant: {
                id: menu.tenant_id,
                name: menu.tenant.name,
                acronym: ApplicationController.helpers.acronym_text(menu.tenant.name)
              },
              category: {
                id: menu.category_id,
                name: menu.category.name
              },
              created_at: menu.created_at,
              updated_at: menu.updated_at
            }
          }
        end
      end
    end

  end
end
