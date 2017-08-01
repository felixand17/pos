class ReportsController < ApplicationController
  authorize_resource :class => false

  def index
    @tenants = Tenant.all.order('name ASC')
  end

  def create
    @tenant = Tenant.includes(order_details: :order).where(id: params[:tenant_id]).first

    start_date = params[:start_date].to_date.beginning_of_day rescue nil
    end_date = params[:end_date].to_date.end_of_day rescue nil

    @order_details =
      @tenant.order_details
             .range_date(start_date, end_date)
             .skip_zero_qty
             .filter_deliver

    @total_order = @order_details.collect { |detail| detail.qty * detail.price }.sum
  end

  def closing_order
    date = params[:start_date] ? params[:start_date] : Time.now
    end_date = params[:end_date] ? params[:end_date] : Time.now

    beginning_of_day = date.to_date.beginning_of_day rescue nil
    end_of_day = end_date.to_date.end_of_day rescue nil

    query =
      "SELECT order_details.tenant_id,
       tenants.name,
       SUM(order_details.qty*order_details.price)
       FROM tenants LEFT JOIN order_details
       ON order_details.tenant_id = tenants.id
       AND (order_details.created_at BETWEEN '#{beginning_of_day}' AND '#{end_of_day}')
       AND (order_details.flag = 'ON PROGRESS' OR order_details.flag = 'DELIVER')
       GROUP BY order_details.tenant_id, tenants.name
       ORDER BY tenants.name ASC;"
    results = ActiveRecord::Base.connection.execute(query)
    @tenant_report = results.values

    category_query =
      "SELECT categories.name,
       SUM(order_details.qty*order_details.price)
       FROM order_details, menus, categories
       WHERE order_details.menu_id = menus.id
       AND menus.category_id = categories.id
       AND (order_details.created_at BETWEEN '#{beginning_of_day}' AND '#{end_of_day}')
       AND (order_details.flag = 'ON PROGRESS' OR order_details.flag = 'DELIVER')
       GROUP BY categories.name
       ORDER BY categories.name ASC;"
    category_results = ActiveRecord::Base.connection.execute(category_query)
    @category_report = category_results.values
  end

  def cashier_revenue
    start_date = params[:start_date].to_date.beginning_of_day rescue nil
    end_date = params[:end_date].to_date.end_of_day rescue nil

    if !start_date.blank? && !end_date.blank?
      @cashier_report =
        Sale.joins(:order)
            .where("orders.created_at BETWEEN '#{start_date}' AND '#{end_date}'")
            .where("orders.state = 'CLOSE'")
            .group('sales.payment_method')
            .sum('sales.amount')

      @detail_cashier_report = {}

      @cashier_report.each do |report, value|
        orders =
          Order.joins(:sale)
              .where("orders.created_at BETWEEN '#{start_date}' AND '#{end_date}'")
              .where("sales.payment_method = '#{report}'")
              .where("orders.state = 'CLOSE'")
              .order('buffet DESC')

        @detail_cashier_report["#{report}"] = orders
      end


      query =
        "SELECT SUM(order_details.qty*order_details.price)
        FROM orders, order_details
        WHERE orders.id = order_details.order_id
        AND (orders.created_at BETWEEN '#{start_date}' AND '#{end_date}')
        AND (orders.state = 'OPEN')
        AND (order_details.flag = 'ON PROGRESS' OR order_details.flag = 'DELIVER')"
      results = ActiveRecord::Base.connection.execute(query)
      @open_order_report = results.values

      @buffet_report =
        Sale.joins(:order)
            .where("orders.created_at BETWEEN '#{start_date}' AND '#{end_date}'")
            .where("orders.state = 'CLOSE'")
            .where("orders.buffet = true")
            .sum('sales.amount')
    end
  end
end
