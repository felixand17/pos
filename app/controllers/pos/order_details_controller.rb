class Pos::OrderDetailsController < Pos::PosController
  before_action :prevent_cashier
  before_action :prepare_order
  before_action :prepare_order_detail, only: [:edit, :update, :delete, :destroy]

  def index
    unless params[:keyword].blank?
      q = params[:keyword].downcase
      @menus = Menu.joins(:tenant).search(q)
    end
  end

  def new
    @menu = Menu.joins(:tenant).where(id: params[:menu_id]).first
    @order_detail = @order.order_details.new(menu_id: params[:menu_id])
  end

  def create
    @order_detail = @order.order_details.new(order_detail_params)
    if @order_detail.save
      flash.keep[:notice] = "Menu is added successfully."
    else
      flash.keep[:alert] = "Failed to add menu."
    end
    redirect_to pos_order_details_path(order_id: params[:id])
  end

  def edit;end

  def update
    if @order_detail.update_item(order_detail_params)
      flash.keep[:notice] = "Menu is updated successfully."
    else
      flash.keep[:alert] = "Failed to update menu."
    end
    redirect_to edit_pos_order_path(id: @order.id)
  end

  def delete;end

  def destroy
    if @order_detail.destroy
      @order.cancel! if @order.order_details.count <= 0
      flash.keep[:notice] = "Menu is deleted successfully."
    else
      flash.keep[:alert] = "Failed to delete menu."
    end
    redirect_to edit_pos_order_path(id: @order.id)
  end

  private

  def prevent_cashier
    return redirect_to '/pos/orders/sales' if current_user.cashier?
  end

  def order_detail_params
    params.require(:order_detail).permit(
      :id, :order_id, :menu_id, :qty, :notes, :flag,
      :adjustment_type, :adjustment_qty
    )
  end

  def prepare_order
    @order = Order.where(id: params[:order_id]).first
  end

  def prepare_order_detail
    @order_detail = @order.order_details.where(id: params[:order_detail_id]).first
  end
end
