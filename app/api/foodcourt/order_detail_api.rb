module Foodcourt
  class OrderDetailApi < Grape::API

    before do
      error!("#{order_exists}", 400) unless order_exists
    end

    helpers do
      def order_exists
        params[:id] && @order = Order.find_by_id(params[:id])
      end

      def prepare_order
        @order
      end

      def order_detail_params
        ActionController::Parameters.new(params).require(:order_detail).permit(
          :id, :order_id, :menu_id, :qty, :notes, :flag, :adjustment_type, :adjustment_qty
        )
      end
    end

    resource :order_detail do
      desc "List all Order Detail per Order"
      params do
        requires :id, type: Integer, desc: 'Order ID.'
      end
      get do
        limit = ( params[:limit].to_i == 0 || params[:limit].empty? ) ? 100 : params[:limit]
        offset = params[:offset]

        order_details_data = []
        prepare_order.order_details.each do |item|
          order_details_data << item.order_detail_json_format
        end

        {
          total: prepare_order.order_details.count,
          count: prepare_order.order_details.count,
          order_id: prepare_order.id,
          data: order_details_data
        }
      end

      namespace do
        before do
          error!("400 Bad Request", 400) unless menu_exists
        end

        helpers do
          def menu_exists
            params[:menu_id] && @menu = Menu.find_by_id(params[:menu_id])
          end
        end

        desc "Add item to Order"
        params do
          requires :id, type: Integer, desc: 'Order ID.'
          requires :menu_id, type: Integer, desc: 'Menu ID.'
          requires :qty, type: Integer, desc: 'Item Order Quantity.'
          optional :notes, type: String
        end
        post do
          item =
            OrderDetail.create!({
              order_id: params[:id],
              menu_id: params[:menu_id],
              qty: params[:qty],
              notes: params[:notes]
            })

          item.order_detail_json_format
        end
      end

      desc "Update item to Order per QTY"
        params do
          requires :id, type: Integer, desc: 'Order ID.'
          requires :detail_id, type: Integer, desc: 'Order Detail ID.'
        end
        put ':detail_id' do
          order_detail = OrderDetail.where(id: params[:detail_id]).first

          if order_detail.update_item(order_detail_params)
            if order_detail.is_draft? || order_detail.is_pending?
              { message: "200 Success" }
            else
              {
                orders: prepare_order.order_json_format,
                detail_items: {
                  id: order_detail.menu_id,
                  name: order_detail.menu_name
                },
                notes: order_detail.notes,
                qty: order_detail.qty,
                adjustment_type: order_detail_params[:adjustment_type],
                adjustment_qty: order_detail_params[:adjustment_qty]
              }
            end
          else
            error!("400 Bad Request", 400)
          end
        end

      desc 'Delete a item.'
        params do
          requires :id, type: Integer, desc: 'Order ID.'
          requires :detail_id, type: Integer, desc: 'Order Detail ID.'
        end
        delete ':detail_id' do
          order_detail = OrderDetail.where(id: params[:detail_id]).first

          if !order_detail.blank? && (order_detail.is_draft? || order_detail.is_pending?)
            if order_detail.delete
              { message: "200 Success" }
            end
          else
            error!("400 Bad Request", 400)
          end
        end
    end
    # End of order
  end
end
