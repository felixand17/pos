class OrdersController < ApplicationController
  load_and_authorize_resource

  def index
    @orders = Order.filter_order(current_user, params)
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      flash.keep[:notice] = "Menu is added successfully."
      redirect_to order_details_path(id: @order.id, order_id: @order.id)
    else
      flash.keep[:alert] = "Failed to add customer."
      redirect_to orders_path
    end
  end

  def edit
    @order = Order.includes(order_details: [:menu]).where(id: params[:id]).first

    user_tenant = current_user.tenant.id rescue nil
    @order_details = @order.order_details
    @order_details = @order_details.where(tenant_id: user_tenant) unless user_tenant.blank?

    @order_logs = PaperTrail::Version.where(item_type: 'Order', item_id: @order.id)
    @order_detail_logs = PaperTrail::Version.where_object(order_id: @order.id)
  end

  def cancel
    @order = Order.where(id: params[:id]).first
    @order.cancel!
    redirect_to orders_path
  end

  def confirm
    @order = Order.includes(order_details: [:menu]).where(id: params[:id]).first
    if current_user.tenant?
      @order.confirm_by_tenant!(current_user.tenant.id)
    else
      @order.confirm!
    end
    redirect_to orders_path
  end

  def set_normal
    @order = Order.includes(order_details: [:menu]).where(id: params[:id]).first

    if @order.update_attributes({ buffet: false, buffet_price: 0 })
      @order.order_details.update_all({ buffet: false })
    end

    redirect_to orders_path
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :customer, :pax, :buffet, :buffet_price)
  end
end
