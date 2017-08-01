module Foodcourt
  class OrderApi < Grape::API

    resource :order do
      desc "List all Order"
        get do
          limit = ( params[:limit].to_i == 0 || params[:limit].empty? ) ? 100 : params[:limit]
          offset = params[:offset]

          order_data = []
          Order.filter_open
               .limit(limit)
               .offset(offset)
               .each do |order|
                  order_data << order.order_json_format
               end

          {
            total: Order.count,
            count: order_data.count,
            data: order_data
          }
        end

      desc "Order Status"
        get :status do
          status_data = []
          Order::STATUS.each do |status|
            status_data << {
              name: status
            }
          end

          {
            total: Order::STATUS.count,
            data: status_data
          }

        end

      desc "Create a new order"
        params do
          requires :name, type: String
        end
        post do
          Rails.logger.info params[:name]
          order =
            Order.create!({ customer: params[:name], user_id: current_user.id })

          order.order_json_format
        end

      desc "Confirm a order"
        params do
          requires :id, type: String, desc: 'Order ID.'
        end
        put '/confirm' do
          order = Order.find(params[:id])

          table_order_items = []
          order_details = order.order_details.filter_draft
          order_details.each do |item|
            table_order_items << item.order_detail_json_format
          end

          captain_order_items = []
          tenants = order_details.map(&:tenant_id).uniq
          tenants.each do |id|
            tenant = Tenant.where(id: id).first
            captain_order_items << {
              tenant: {
                id: tenant.id,
                name: tenant.name
              },
              items: order_details.where(tenant_id: id).each{|item|
                item.order_detail_json_format
              }
            }
          end


          if order.confirm!
            {
              orders: order.order_json_format,
              table_orders: table_order_items,
              captain_orders: captain_order_items
            }
          else
            error!("400 Bad Request", 400)
          end
        end
    end
    # End of order
  end
end
