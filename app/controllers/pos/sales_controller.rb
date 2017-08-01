class Pos::SalesController < Pos::PosController
  before_action :prepare_order

  def index
    @keyword = "#{params[:keyword]}".downcase
    @orders = Order.search(@keyword).filter_open_only
  end

  def new
    if @order.order_details.blank?
      flash.keep[:alert] = "Detail is not available."
      return redirect_to '/pos/orders/sales'
    end

    @payment_method =
      (cannot? :manage, Sale) ? Sale::STANDARD_PAYMENT_METHOD : Sale::PAYMENT_METHOD

    @order_details = @order.order_details.filter_deliver
    @buffet_items = @order_details.include_buffet if @order.buffet
    @order_details = @order_details.exclude_buffet if @order.buffet

    @sale = Sale.new({
      order_id: @order.id,
      amount: @order.total_amount_tax,
      user_id: current_user.id
    })
  end

  def bill
    unless params[:sale].blank?
      sale = Sale.new({
        order_id: params[:sale][:order_id],
        user_id: current_user.id,
        amount: params[:sale][:amount],
        discount: params[:sale][:discount],
        bill_only: true
      })
      sale.prepare_discount
      sale.print_bill
    end
  end

  def bulk_bill
    PrintingAllBillJob.perform_later(current_user)

    flash.keep[:notice] = "Print all bill ..."
    redirect_to '/pos/orders/sales'
  end

  def create
    @sale = Sale.new(sale_params)

    if sale_params[:payment].to_f >= sale_params[:amount].to_f && @sale.save
      flash.keep[:notice] = "Payment has been successfully."
      @order.close!
    else
      flash.keep[:alert] = "Transaction could not be processed."
    end
    redirect_to '/pos/orders/sales'
  end

  def calculate_discount
    discount =
      (params[:discount].to_i <= 100 ? params[:discount].to_f : 100.to_f) / 100

    total_discount = @order.total_amount * discount
    total_after_discount = @order.total_amount_tax - total_discount

    @sale = Sale.new({
      order_id: @order.id,
      amount: total_after_discount,
      user_id: current_user.id
    })
  end

  private

  def sale_params
    params.require(:sale).permit(
      :id,
      :order_id,
      :user_id,
      :reference_number,
      :amount,
      :payment_method,
      :payment,
      :tax,
      :service,
      :discount,
      :discount_amount
    )
  end

  def prepare_order
    @order = Order.where(id: params[:id]).first
  end
end
