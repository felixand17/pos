class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    return redirect_to pos_orders_path if current_user.waitres?
    return redirect_to '/pos/orders/sales' if current_user.cashier?
  end
end
