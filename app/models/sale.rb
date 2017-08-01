class Sale < ApplicationRecord
  PAYMENT_METHOD = [
    'CASH',
    'DEBIT',
    'COMPLIMENT'
  ]

  STANDARD_PAYMENT_METHOD = [
    'CASH',
    'DEBIT'
  ]

  belongs_to  :order
  belongs_to  :user

  has_paper_trail

  attr_accessor :bill_only, :server_printing

  validates :payment_method, presence: true

  scope :range_date, -> (start_date, end_date) { where(created_at: start_date..end_date) }

  before_save :prepare_discount
  after_create  :close_order
  after_create  :print_bill

  def is_compliment?
    payment_method.eql?('COMPLIMENT')
  end

  def save_sale(params)
    return false if self.
    if sale_params[:payment] >= sale_params[:amount] && @sale.save
  end

  def change
    payment - order.total_amount_tax rescue 0
  end

  def prepare_discount
    disc = self.discount.to_i <= 100 ? self.discount.to_f : 100.to_f
    disc_float = disc / 100
    total_discount = self.order.total_amount * disc_float

    self.discount = disc
    self.discount_amount = total_discount
    self.tax = self.order.order_tax

    option = Option.where(option_name: 'enable_service').first
    self.service = !option.blank? && option.option_value.eql?('true') ? self.order.order_service : 0.0
    self.amount = self.order.total_amount_tax - total_discount
  end

  def sale_to_json_format
    order_details_data = []
    order.order_details.filter_deliver.each do |item|
      order_details_data << item.order_detail_json_format
    end

    {
      id: id,
      order: {
        id: order_id,
        code: order.code,
        customer: order.customer,
        waitres: {
          id: order.user_id,
          name: order.user.name
        },
        status: order.state
      },
      items: order_details_data,
      user: {
        id: user_id,
        name: user.name
      },
      order_total: order.total_amount,
      tax: order.order_tax,
      total: order.total_amount_tax,
      change: change,
      payment_method: payment_method,
      payment: payment,
      created_at: created_at,
      updated_at: updated_at
    }
  end

  def close_order
    self.order.close!
  end

  def print_bill
    # return unless server_printing
    if bill_only
      PrintingCashierJob.perform_now(self, self.order)
      return
    end

    limit = 2
    print_count = 0
    loop do
      PrintingCashierJob.perform_now(self, self.order)
      print_count += 1
      break if print_count >= limit
    end
  end
end
