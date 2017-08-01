class Pos::OrdersController < Pos::PosController
  before_action :prevent_cashier
  before_action :prepare_order

  def index
    @keyword = "#{params[:keyword]}".downcase

    unless @keyword.blank?
      @orders = Order.search(@keyword).filter_open

      if @orders.blank?
        @order = Order.new({
          user_id: current_user.id,
          customer: @keyword
        })
      end
    end
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      flash.keep[:notice] = "Customer is created successfully."
      return redirect_to edit_pos_order_path(@order.id)
    else
      flash.keep[:alert] = "Failed to add menu."
      @errors = @order.errors.full_messages.to_senetence
      redirect_to pos_orders_path
    end
  end

  def edit
    if @order.order_details.blank?
      return redirect_to pos_order_details_path(order_id: @order.id)
    end
    @order_details = @order.order_details.includes(:menu)

    @order_logs = PaperTrail::Version.where(item_type: 'Order', item_id: @order.id)
    @order_detail_logs = PaperTrail::Version.where_object(order_id: @order.id)
  end

  def confirm
    @order.confirm!(current_user)
    redirect_to pos_orders_path
  end

  private

  def prevent_cashier
    return redirect_to '/pos/orders/sales' if current_user.cashier?
  end

  def order_params
    params.require(:order).permit(:user_id, :customer, :pax, :buffet, :buffet_price)
  end

  def prepare_order
    @order = Order.where(id: params[:id]).first
  end
end
