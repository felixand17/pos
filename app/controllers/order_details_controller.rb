class OrderDetailsController < ApplicationController
  before_action :prepare_order
  before_action :prepare_order_detail
  before_action :set_paper_trail_whodunnit
  load_and_authorize_resource

  def index
    q = "#{params[:keyword]}".downcase
    if current_user.admin?
      @menus = Menu.joins(:tenant).search(q)
    else
      @menus = Menu.joins(:tenant).by_tenant(current_user.tenant.id).search(q)
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

    redirect_to order_details_path(order_id: params[:order_id])
  end

  def destroy
    @order_detail.destroy
    redirect_to edit_order_path(order_id: params[:order_id])
  end

  def confirm
    @order_detail.to_onprogress!
    redirect_to orders_path
  end

  def reject
    if request.put?
      @order_detail.to_rejected!(params[:comment])
      redirect_to edit_order_path(order_id: params[:order_id])
    end
  end

  def deliver
    @order_detail.to_deliver!
    redirect_to orders_path
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:id, :order_id, :menu_id, :qty, :notes, :flag)
  end

  def prepare_order
    @order = Order.where(id: params[:order_id]).first
  end

  def prepare_order_detail
    @order_detail = @order.order_details.where(id: params[:order_detail_id]).first
  end
end
