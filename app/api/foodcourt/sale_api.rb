module Foodcourt
  class SaleApi < Grape::API

    resource :sales do
      desc "List all Order for cashier"
      get :order do
        limit = ( params[:limit].to_i == 0 || params[:limit].empty? ) ? 100 : params[:limit]
        offset = params[:offset]
        status = 'OPEN'

        order_data = []
        Order.where("state = ?", status)
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

      namespace do
        before do
          error!("400 Bad Request", 400) unless order_exists
        end

        helpers do
          def order_exists
            params[:id] && @order = Order.is_open(params[:id]).first
          end

          def prepare_order
            @order
          end
        end

        desc "Get an Order for cashier"
          params do
            requires :id, type: Integer, desc: 'Order id.'
          end
          get '/order/:id' do
            {
              data: prepare_order
            }
          end

        desc "Get an Order Item for cashier"
          params do
            requires :id, type: Integer, desc: 'Order id.'
          end
          get '/order/:id/details' do
            order_details_data = []
            prepare_order.order_details.filter_deliver.each do |item|
              order_details_data << item.order_detail_json_format
            end

            {
              data: {
                order: prepare_order.order_json_format,
                items: order_details_data,
                amount: prepare_order.total_amount,
                tax: prepare_order.order_tax,
                total: prepare_order.total_amount_tax
              }
            }
          end

        desc "Sale a Order"
          params do
            requires :id, type: Integer, desc: 'Order ID.'
            requires :payment_method, type: String, desc: 'Payment Method: CASH/DEBIT.'
            requires :payment, type: Float, desc: 'Payment.'
          end
          post '/order/:id/payment' do
            if params[:payment] >= prepare_order.total_amount_tax
              server_printing = params[:server_printing].blank? ? true : params[:server_printing]

              sale =
                Sale.new({
                  order_id: prepare_order.id,
                  user_id: current_user.id,
                  amount: prepare_order.total_amount_tax,
                  payment_method: params[:payment_method],
                  payment: params[:payment],
                  reference_number: params[:reference_number],
                  server_printing: server_printing
                })

              sale.save
              sale.sale_to_json_format
            else
              error!("400 Bad Request", 400)
            end
          end

        desc "Print Bill"
          params do
            requires :id, type: Integer, desc: 'Order ID.'
          end
          post '/order/:id/bill' do
            sale = Sale.new({
              order_id: params[:id],
              user_id: current_user.id,
              bill_only: true
            })

            server_printing = params[:server_printing] ? params[:server_printing] : true
            sale.print_bill if server_printing
            sale.sale_to_json_format
          end
      end
    end
    # End of sales
  end
end
