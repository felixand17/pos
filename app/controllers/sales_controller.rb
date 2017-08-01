class SalesController < ApplicationController
  before_action :prepare_order
  load_and_authorize_resource

  def new
    @sale = Sale.new({order_id: @order.id, amount: @order.total_amount_tax, user_id: current_user.id})
  end

  def create
    @sale = Sale.new(sale_params)
    if @sale.save
      @order.close!
    end
    redirect_to orders_path
  end

  private

  def sale_params
    params.require(:sale).permit(:order_id, :user_id, :amount, :payment_method, :payment, :tax, :service)
  end

  def prepare_order
    @order = Order.where(id: params[:id]).first
  end
end
